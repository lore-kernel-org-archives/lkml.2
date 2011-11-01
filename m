Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1KANqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:46:10 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:55860 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678Ab1KANqI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:46:08 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 09:46:08 EDT
X-AuditID: 1209190c-b7f806d0000008d6-b9-4eaff6f2391b
Subject: =?windows-1252?Q?Re=3A_ext4_bug_=3F_=22Intel_320_SSD_write_perfo?=
 =?windows-1252?Q?rmance_=96_contd=2E=22?=
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4EAFF54C.7010406@earthlink.net>
Date: Tue, 1 Nov 2011 09:41:06 -0400
Cc: Theodore Tso <tytso@MIT.EDU>, Vincent Pelletier <plr.vincent@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C838F22F-D7B1-4911-B6F6-214240A77859@mit.edu>
References: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com> <20111031210951.GK16825@thunk.org> <4EAFF54C.7010406@earthlink.net>
To: sclark46@earthlink.net
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42IR4hTV1v38bb2fweUORovLu+awWey9cIPF
	4tSsA0wOzB6rvkxg9tg56y67x+dNcgHMUVw2Kak5mWWpRfp2CVwZ8/ovsRcc4a2Yc1CzgXEl
	VxcjJ4eEgInEqq1TGCFsMYkL99azdTFycQgJ7GOUePW8iQkkISSwnlFia08CRGIFk8TXa89Y
	QBLCAuUS737NZwOxeQWMJdbcegcWZxbQk9hx/RcriM0moCRx59N+sDingK7Ejc4jzCA2i4CK
	xILzDewQ9UUS5w/eYYWwtSWWLXzNDDHTSuL50dMsEIunMEqs+3sB7CIRASmJpZvfMkOcLS/R
	8vUO2wRGwVlI7piF5I5ZSOYuYGRexSibklulm5uYmVOcmqxbnJyYl5dapGuol5tZopeaUrqJ
	ERzSkjw7GN8cVDrEKMDBqMTDG3hwnZ8Qa2JZcWXuIUZJDiYlUd4Xn9f7CfEl5adUZiQWZ8QX
	leakFh9ilOBgVhLh9V8GVM6bklhZlVqUD5OS5mBREuc9uMPBT0ggPbEkNTs1tSC1CCYrw8Gh
	JMHrAYxdIcGi1PTUirTMnBKENBMHJ8hwHqDhTiA1vMUFibnFmekQ+VOMuhx3GxefYhRiycvP
	S5US5w0GKRIAKcoozYObA0tFrxjFgd4S5rUDqeIBpjG4Sa+AljABLZl5CWxJSSJCSqqBUfgj
	y6ob1RH++Qdby6aqaFRuYhZ5sCcl4tvTzSeuba5z3l4TMq+Cx/Lw/FfcU/fNq3ttmfHltY9n
	jVGE1uvv5k/KsxR/unYaXc9RVbyy+Icu0/T6/413RO4+W+bdVnUlMGmh+Os5Zj+sp/2fvCFL
	9eD/ykXr3uyQdV1zZ1tZUOHa+2K/ZNdve6DEUpyRaKjFXFScCAAvxT6kIAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2011, at 9:34 AM, Stephen Clark wrote:

>> 
>> You can enable the trim behaviour by default by adding to your
>> /etc/mke2fs.conf file:
>> 
>> [defaults]
>> 	discard = true
>> 
>> But then it's on your head if anything bad happens.  :-/
>> 
>>         	      	      	      - Ted
>> 
>>   
> <snip>
> 
> What about using discard in fstab like:
> LABEL=/ /                      ext4    defaults,discard,noatime,nodiratime        1 1

That does something different; this does continuous discards as you delete files.   This is probably the best thing to do if you are using thin-provisioning.   However, with SATA devices, a discard requires a queue flush, which can be a performance disaster.   (Also some cheaper SSD's also have real performance difficulties if there are frequent trims.)   There have also been reports that high frequency discards can trigger bugs that cause crappier SSD's to turn themselves into bricks.   The performance problems and the possibility of bricking crappier SSD's is why this isn't turned on by default.

Because of this, another method is to do FITRIM's periodically using cron.   This has less of a performance impact, so it's probably the better approach in many cases.

Basically, with SSD's and thin-provisioning systems, we are very much at the mercy at the competence of firmware authors.   As we know, sometimes firmware authors can be quite competent, or very, extremely incompetent.   So there will be a wide range of outcomes, which is one of the reasons why the best answer is to test to see what works best for you, preferably before you put use your systems in production.

-- Ted


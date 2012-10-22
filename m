Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2JVSjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:39:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43584 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755830Ab2JVSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:39:40 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Xk7lHiQgXF/rhfFHwWLPL7Wg9E/f/T7j9o5MFA0
	TWZ0eQJ+lFli4n
Message-ID: <5085923F.9050801@gmx.de>
Date: Mon, 22 Oct 2012 20:36:47 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error w/ external USB drive
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org>
In-Reply-To: <20121019210723.GA4721@thunk.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:07 PM, Theodore Ts'o wrote:
> On Mon, Oct 15, 2012 at 07:46:02PM +0200, Toralf Förster wrote:
>> Even with current stable kernel 3.6.2 I sometimes get those syslog messages :
>>
>>
>> 2012-10-15T19:37:58.401+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 22901 in gd
> 
> Have you run e2fsck to clean up the file system corruption?  If you
> have, do you continually get these errors afterwards?

Well, I got it yesterday too :

n22 ~ # zgrep  ext4_mb_generate_buddy /var/log/messages-201210*                                                                                                                       
/var/log/messages-20121021.gz:2012-10-15T19:05:39.189+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 774, 27157 clusters in bitmap, 27052 in gd       
/var/log/messages-20121021.gz:2012-10-15T19:37:58.401+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 22901 in gd       
/var/log/messages-20121021.gz:2012-10-15T19:56:05.301+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 1233, 11981 clusters in bitmap, 11974 in gd      
/var/log/messages-20121021.gz:2012-10-15T19:56:18.601+02:00 n22 kernel: EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 484, 28817 clusters in bitmap, 28101 in gd      

I rebooted the system and forced a run of fsck after these lines too.
I'll check periodically whether it happens again.
 
> You say this is an external USB disk; is there any possibility of the
> disk getting unmounted uncleanly due to the cable getting pulled out
> while the disk is still mounted, and then the disk getting remounted
> w/o having e2fsck run on the disk?

For the first occurrence probably yes (better : I dunno), but yesterday definitely not.



-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

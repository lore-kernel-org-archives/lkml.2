Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2AIP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:56:37 -0500
Received: from nm18-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.210]:36434 "HELO
	nm18-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755706Ab2AIP4f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:56:35 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 10:56:35 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 846119.53344.bm@omp1030.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=d2tj4kUbobI7J+NXQPmDCWZZ/B2j7V6T76TGave+xA20+1lSV02bmZ3X0Puc3ouhSv/6zuXm3fBCzC6alsFotJmUVtFXGl4C6g+fg5GKv5lJRG9ViYbEItgE2O8AutKY2vrs0K3fx/7kMq6DyDQ8Z5fNIaivuRA5CF8+0XuXmmo=;
X-YMail-OSG: RfIktFoVM1mxDJEopMui5wbPyqugeKl0jTA2yd.oM1rvJki
 txQORmVXLNzom80oviuAOBjeTcRZrT_7vTsp7mw1A.Ggm2ob9jqeINJpLxD2
 fCqaOf2DXKhpvRFsj3HtGieMUc1H1QdI2TC563H1rbhYUz4QpGJbvUqN89wO
 VA6GKYgYY1wG7Tbl05LIu2g005Ltn.i2ri7SBYr8_rRl2jenZOonK_ow20b.
 sWoFAuCzSNAdbgfQt4tcCmid0bdSJBjKbGT9UlCiQu1dd0w8LqL0hB.v8sQG
 8OqYNXKWAEYWU1QHcAQA5TB1jFIEfqyWv3YsuFWjnSA3ddDxSvwbo7AocmCb
 kVKyuET3VnY1rh46Ym_.B8HWzGz79mX1rklLzPqkzx0X3eRKQMvGpVzabcHJ
 6qk8B_cFgn7hch4v1FgkLjktCZCX69DvRSWKfpoNQktWO1iHZKXRv2waI7lE
 jsGG7
X-Mailer: YahooMailWebService/0.8.115.331698
References: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com> <20120109151707.GB22175@thunk.org>
Message-ID: <1326124193.94662.YahooMailNeo@web38004.mail.mud.yahoo.com>
Date: Mon, 9 Jan 2012 07:49:53 -0800 (PST)
From: Shantanu Goel <sgoel01@yahoo.com>
Reply-To: Shantanu Goel <sgoel01@yahoo.com>
Subject: Re: [PATCH] ext4: Fix up range_end offset in range cyclic writeback
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120109151707.GB22175@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending as vger didn't like the HTML message so apologies for the duplicate Ted]


Hi Ted,

Thanks for confirming the fix is good.  We noticed that kupdate writebacks were happening at 
irregular intervals and started inspecting the VM writeback code which 
seemed to be doing its job correctly, and were eventually led to the 
ext4 writeback code.  Without the fix, it was sometimes take a very long time for a file to be flushed to disk asynchronously though synchronous flushes worked fine.  It would be nice if the fix could be included in 
3.3 release cycle.


Regards,Shantanu



________________________________
From: Ted Ts'o <tytso@mit.edu>
To: Shantanu Goel <sgoel01@yahoo.com> 
Cc: Kernel <linux-kernel@vger.kernel.org> 
Sent: Monday, January 9, 2012 10:17 AM
Subject: Re: [PATCH] ext4: Fix up range_end offset in range cyclic writeback

On Sat, Jan 07, 2012 at 07:23:32PM -0800, Shantanu Goel wrote:
> 
> 
> The patch below fixes the range_end calculation which should be a
> byte offset and not a page index.  Also, the patch updates the `end'
> index as well when looping again in range cyclic mode.

Hi Shantanu,

This patch looks good; thanks for spotting this!  Can I ask how you
spotted this and whether it was by code inspection because the
incorrect code was causing some serious problem?

Basically, it's late in the merge window, and I'd rather not include
any new patches unless they are fixing a serious problem at this
point.  Otherwise, I'll make sure it gets merged for the next merge
window.

Thanks,

                        - Ted

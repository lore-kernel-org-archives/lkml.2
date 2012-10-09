Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2JIUVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:21:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42682 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2JIUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:20:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Myklebust\, Trond" <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "linux-nfs\@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@openvz.org" <devel@openvz.org>
References: <20121008105437.18668.99905.stgit@localhost.localdomain>
	<20121009193506.GA19680@fieldses.org>
	<4FA345DA4F4AE44899BD2B03EEEC2FA90901A143@SACEXCMBX04-PRD.hq.netapp.com>
Date: Tue, 09 Oct 2012 13:20:48 -0700
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA90901A143@SACEXCMBX04-PRD.hq.netapp.com>
	(Trond Myklebust's message of "Tue, 9 Oct 2012 19:49:46 +0000")
Message-ID: <87txu3bdnj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PQDmZ5AEoiN/JUI1krriBIV21RIzC/hY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Myklebust\, Trond" <Trond.Myklebust@netapp.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before connecting local transports
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:

> On Tue, 2012-10-09 at 15:35 -0400, J. Bruce Fields wrote:
>> Cc'ing Eric since I seem to recall he suggested doing it this way?

Yes.  On second look setting fs->root won't work. We need to change fs.
The problem is that by default all kernel threads share fs so changing
fs->root will have non-local consequences.

I very much believe we want if at all possible to perform a local
modification.

Changing fs isn't all that different from what devtmpfs is doing.

>> Seems OK to me, but maybe that swap_root should be in common code?  (Or
>> maybe we could use set_fs_root()?)
>> 
>> I'm assuming it's up to Trond to take this.--b.
>
> I'm reluctant to do that at this time since the original proposal was
> precisely that of export set_fs_root() and using it around the AF_LOCAL
> socket bind. That proposal was NACKed by Al Viro.

> If Al is OK with the idea of us creating a private version of
> set_fs_root, then I'd like to see an official Acked-by: that we can
> append to this commit.

Eric


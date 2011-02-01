Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1BAQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:37:34 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:61507 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1BAQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:37:32 -0500
Subject: Re: [PATCH] security/selinux: fix /proc/sys/ labeling
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Nick Piggin <npiggin@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <AANLkTi=wAXO0+gC=Cvh8EcJKOQW6-LSuO_tm2MsrtQQ6@mail.gmail.com>
References: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com>
	 <1296572538.12605.4.camel@moss-pluto>
	 <AANLkTimiV_2SAwXuH-SjGav5XJixN=SnjrPrtFRRQF05@mail.gmail.com>
	 <1296575975.12605.18.camel@moss-pluto>
	 <AANLkTi=wAXO0+gC=Cvh8EcJKOQW6-LSuO_tm2MsrtQQ6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Tue, 01 Feb 2011 11:37:26 -0500
Message-ID: <1296578246.12605.22.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 18:32 +0200, Lucian Adrian Grijincu wrote:
> On Tue, Feb 1, 2011 at 5:59 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >> Just the earlier one. I added his sign-off because of this paragraph
> >> in SubmittingPatches:
> >> | The Signed-off-by: tag indicates that the signer was involved in the
> >> | development of the patch, or that he/she was in the patch's delivery path.
> 
> 
> So should I leave Eric's sign-off here?

I guess so, given that paragraph.

> >> Without we label all nodes in /proc/ through selinux_proc_get_sid.
> >>
> >> /proc/1/limits should not get it's sid from here, but from
> >> security_task_to_inode -> selinux_task_to_inode.
> >>
> >> Without the check we send "/1/limits" to selinux_proc_get_sid, which
> >> strips off "/1" leaving "/limits". This will be labeled with "proc_t"
> >> IIRC.
> >
> > Are you sure?  Those inodes should be labeled by proc_pid_make_inode()
> > -> security_task_to_inode() -> selinux_task_to_inode(), which will set
> > the inode SID to match the associated task SID, and set the
> > isec->initialized flag.  Then when inode_doinit_with_dentry gets called
> > later, it should bail immediately due to isec->initialized already being
> > set.
> 
> 
> 
> I'll post an updated patch without those checks. I tested and 'find
> /proc | xargs ls -Z' said the same thing with and without those
> checks.
> 
> I remember doing the same test yesterday and saw some differences, but
> I must have compared the wrong files.

Ok, good.  That gets rid of the last vestige of proc implementation
details in selinux.

-- 
Stephen Smalley
National Security Agency


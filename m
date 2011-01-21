Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1AUTuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:50:20 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:45364 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752390Ab1AUTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:50:17 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 50DgY.IVM1kdzWZNJUI3fz2wIOj5wlFGFFasZZ6BIVS.FE5
 Uw15GEa9DwW72rlf.KNQG9FcOdzk.t2fPEeWqjHjo86hlV17S5XPhn_dXN2y
 cl8HVS1Jw6bzUlIoW_PVN26wXp6r9a_EtXHEYiMnmClDSkq52VEY1ZI3g5jR
 __UDQGQKhvq.LbFOBY55cwILuC1xcSNpiQr790nP5ZkNDOKoIkvNwpQPF6Xt
 pfsz_NRVml4Yf8ftfF.k-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D39E377.2090102@schaufler-ca.com>
Date: Fri, 21 Jan 2011 11:50:15 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        takedakn@nttdata.co.jp, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: SELinux/SMACK/TOMOYO: ioctl permissions handling is wrong and
 nonsensicle
References: <1295638239.3403.15.camel@localhost.localdomain>
In-Reply-To: <1295638239.3403.15.camel@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2011 11:30 AM, Eric Paris wrote:
> [I've included an AA person as well in case you ever decide to try to
> mediate ioctl operations]
>
> SELinux used to recognize certain individual ioctls and check
> permissions based on the knowledge of the individual ioctl.  In commit
> 242631c49d4cf396 the SELinux code stopped trying to understand
> individual ioctls and to instead looked at the ioctl access bits to
> determine in we should check read or write for that operation.  This
> same suggestion was made to SMACK (and I believe copied into TOMOYO).
> But this suggestion is total rubbish.

Bugger bugger bugger ... (you get the idea) ... bugger.

This means calling out each and every ioctl separately,
unless someone has a magic access behavior detector for
device drivers. You can't even assume that two devices
that share an ioctl are going to do the same thing with
it. In the old Orange Book days almost half the work on
describing the access control implementation went into
iotcls and fcntls. Bugger.

What strategy is SELinux planning to take on getting the
ioctls right, and more importantly, keeping them correct
going forward?

> The ioctl access bits are
> actually the access requirements for the structure being passed into the
> ioctl, and are completely unrelated to the operation of the ioctl or the
> object the ioctl is being performed upon.
>
> Take FS_IOC_FIEMAP as an example.  FS_IOC_FIEMAP is defined as:
>
> FS_IOC_FIEMAP _IOWR('f', 11, struct fiemap)
>
> So it has access bits R and W.  What this really means is that the
> kernel is going to both read and write to the struct fiemap.  It has
> nothing at all to do with the operations that this ioctl might perform
> on the file itself!

Grrrrr.

> If anything, our logic is exactly backwards, since an ioctl which writes
> to userspace would be 'reading' something from the file and an ioctl
> which reads from userspace would be 'writing' something to the file...
>
> I'm planning to revert this SELinux commit, but I want other LSM authors
> to realize that (assuming I'm not completely off in the woods somewhere)
> you should take a look at your ioctl permissions checking as well....

Yeah. Good fun, that. Any chance we could share strategic thinking?
I hate the notion of brute forcing each ioctl, having done it in the
past for a system with lots fewer ioctls than Linux is supporting.

> -Eric

Thank you for the heads up on this. Bugger ... bugger.


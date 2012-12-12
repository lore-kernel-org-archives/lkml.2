Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2LLSpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:45:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2LLSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:45:33 -0500
Date: Wed, 12 Dec 2012 12:45:20 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121212184520.GA1797@serge-ThinkPad-X130e>
References: <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com>
 <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
 <CALCETrXC9hnBtqHguHh_tXphNutarPYj-nnUA_VAtY9XsfSbpA@mail.gmail.com>
 <CALCETrWa10sLekJZaaRBJOJW8jnNNWNMy0pVTeu5+OvxS6ZY9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWa10sLekJZaaRBJOJW8jnNNWNMy0pVTeu5+OvxS6ZY9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Sat, Dec 8, 2012 at 3:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > I just tried to search to find actual uses of pI/fI.  Here's what I found:
> 
> I downloaded all the Fedora spec files and searched for file
> capabilities.  Assuming I didn't mess up, here's what I found:
> 
> fping.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/fping
> fping.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/fping6
> glibc.spec:%attr(755,root,root) %caps(cap_chown,cap_fowner=pe)
> %{_prefix}/libexec/pt_chown
> gnome-keyring.spec:%attr(0755,root,root) %caps(cap_ipc_lock=ep)
> %{_bindir}/gnome-keyring-daemon
> httpd.spec:%caps(cap_setuid,cap_setgid+pe)
> %attr(510,root,%{suexec_caller}) %{_sbindir}/suexec
> iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/clockdiff
> iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/arping
> iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep
> cap_net_admin=ep) %{_bindir}/ping
> iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep
> cap_net_admin=ep) %{_bindir}/ping6
> mtr.spec:%attr(0755,root,root) %caps(cap_net_raw=pe) %{_sbindir}/mtr
> policycoreutils.spec:%caps(cap_setpcap,cap_setuid,cap_fowner,cap_dac_override,cap_sys_admin,cap_sys_nice=pe)
> %{_sbindir}/seunshare
> policycoreutils.spec:%attr(0755,root,root)
> %caps(cap_setpcap,cap_audit_write,cap_sys_admin,cap_fowner,cap_chown,cap_dac_override=pe)
> %{_bindir}/newrole
> rpm.spec:- fix double-free on %caps in spec (#877512)
> rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rcp
> rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rlogin
> rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rsh
> systemd.spec:%caps(cap_dac_override,cap_sys_ptrace=pe)
> %{_bindir}/systemd-detect-virt
> wireshark.spec:%attr(0750, root, wireshark)
> %caps(cap_net_raw,cap_net_admin=eip) %{_sbindir}/dumpcap
> xorg-x11-server.spec:%global Xorgperms %attr(0711,root,root)
> %caps(cap_sys_admin,cap_sys_rawio,cap_dac_override=pe)
> 
> The only inheritable bit is on dumpcap, and it's not necessary there.

These are all cases of using caps to replace setuid-root.  In itself this
doesn't make the point you're aiming to make.  At the same time I don't
dispute that you may be right that almost noone is using fI the way we'd
like.

The reason I was in an earlier email laying out how a sudo-adm-like
replacement could work is that I do think we're missing some userspace
plumbing to make use of fI easier.  We miss a tool to easily say "let
joe use /usr/bin/X with caps Y".  We miss a way for packaging tools to
easily say "create a new user foo which has pI=xyz" and "install bar
so that foo can run it with fI=xyz (by placing a copy under
/var/lib/privs/foo).  And we miss a one-liner for init scripts to
launch services as a specific user that way.

That still doesn't address the wrapper issue you raised, though it
could lead to a design to solve it.

-serge

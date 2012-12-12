Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2LLS3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:29:41 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62210 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2LLS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:29:37 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXC9hnBtqHguHh_tXphNutarPYj-nnUA_VAtY9XsfSbpA@mail.gmail.com>
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com> <CALCETrXC9hnBtqHguHh_tXphNutarPYj-nnUA_VAtY9XsfSbpA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Dec 2012 10:29:17 -0800
Message-ID: <CALCETrWa10sLekJZaaRBJOJW8jnNNWNMy0pVTeu5+OvxS6ZY9A@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 3:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I just tried to search to find actual uses of pI/fI.  Here's what I found:

I downloaded all the Fedora spec files and searched for file
capabilities.  Assuming I didn't mess up, here's what I found:

fping.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/fping
fping.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/fping6
glibc.spec:%attr(755,root,root) %caps(cap_chown,cap_fowner=pe)
%{_prefix}/libexec/pt_chown
gnome-keyring.spec:%attr(0755,root,root) %caps(cap_ipc_lock=ep)
%{_bindir}/gnome-keyring-daemon
httpd.spec:%caps(cap_setuid,cap_setgid+pe)
%attr(510,root,%{suexec_caller}) %{_sbindir}/suexec
iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/clockdiff
iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep) %{_sbindir}/arping
iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep
cap_net_admin=ep) %{_bindir}/ping
iputils.spec:%attr(0755,root,root) %caps(cap_net_raw=ep
cap_net_admin=ep) %{_bindir}/ping6
mtr.spec:%attr(0755,root,root) %caps(cap_net_raw=pe) %{_sbindir}/mtr
policycoreutils.spec:%caps(cap_setpcap,cap_setuid,cap_fowner,cap_dac_override,cap_sys_admin,cap_sys_nice=pe)
%{_sbindir}/seunshare
policycoreutils.spec:%attr(0755,root,root)
%caps(cap_setpcap,cap_audit_write,cap_sys_admin,cap_fowner,cap_chown,cap_dac_override=pe)
%{_bindir}/newrole
rpm.spec:- fix double-free on %caps in spec (#877512)
rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rcp
rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rlogin
rsh.spec:%attr(0755,root,root)  %caps(cap_net_bind_service=pe) %{_bindir}/rsh
systemd.spec:%caps(cap_dac_override,cap_sys_ptrace=pe)
%{_bindir}/systemd-detect-virt
wireshark.spec:%attr(0750, root, wireshark)
%caps(cap_net_raw,cap_net_admin=eip) %{_sbindir}/dumpcap
xorg-x11-server.spec:%global Xorgperms %attr(0711,root,root)
%caps(cap_sys_admin,cap_sys_rawio,cap_dac_override=pe)

The only inheritable bit is on dumpcap, and it's not necessary there.

--Andy

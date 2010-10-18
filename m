Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0JRHO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:14:28 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:43663 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab0JRHO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:14:27 -0400
Message-ID: <4CBBF3C8.9070104@web.de>
Date: Mon, 18 Oct 2010 09:14:16 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <20101017085416.GA1758@darkstar>	<4CBAC342.1010609@redhat.com>	<AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	<4CBAE8E2.1060704@redhat.com> <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
In-Reply-To: <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE2CA6A11C1F714CC5C67FDE"
X-Provags-ID: V01U2FsdGVkX1+B4XruwJjyfH1ayy3GWbrERas7xYz5DlNq9muT
	88+iBlhEm76kAr+6O8HFGombzpUaME8Y0D+sj4yvsYuMJx71WH
	/GQjEFzZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE2CA6A11C1F714CC5C67FDE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 18.10.2010 06:43, Dave Young wrote:
> On Sun, Oct 17, 2010 at 8:15 PM, Avi Kivity <avi@redhat.com> wrote:
>>  On 10/17/2010 12:14 PM, Dave Young wrote:
>>>
>>> On Sun, Oct 17, 2010 at 5:34 PM, Avi Kivity<avi@redhat.com>  wrote:
>>>>    On 10/17/2010 10:54 AM, Dave Young wrote:
>>>>>
>>>>>  linux guest can not startup normally, qemu keep rebooting.
>>>>>
>>>>>  host&    guest both use linux-2.6.36-rc8+ kernel
>>>>>
>>>>>  Add a dump_stack in x86.c around EXIT_SHUTDOWN code, I got:
>>>>>  [ 3924.503041] Pid: 1685, comm: qemu-system-x86 Not tainted
>>>>> 2.6.36-rc8+
>>>>>  #62
>>>>>  [ 3924.503045] Call Trace:
>>>>>  [ 3924.503055]  [<ffffffffa0176047>] handle_triple_fault+0x11/0x26=

>>>>>  [kvm_intel]
>>>>>  [ 3924.503060]  [<ffffffffa01772d2>] vmx_handle_exit+0x3df/0x474
>>>>>  [kvm_intel]
>>>>>  [ 3924.503080]  [<ffffffffa021f203>]
>>>>> kvm_arch_vcpu_ioctl_run+0x95f/0xc43
>>>>>  [kvm]
>>>>>  [ 3924.503087]  [<ffffffff81503e54>] ?
>>>>> __mutex_unlock_slowpath+0x11c/0x131
>>>>>  [ 3924.503101]  [<ffffffffa021e1f9>] ? kvm_arch_vcpu_load+0x90/0xe=
6
>>>>> [kvm]
>>>>>  [ 3924.503112]  [<ffffffffa0210faf>] kvm_vcpu_ioctl+0x109/0x54a [k=
vm]
>>>>>  [ 3924.503117]  [<ffffffff810bee76>] ?
>>>>>  fire_user_return_notifiers+0x2c/0x36
>>>>>  [ 3924.503122]  [<ffffffff8106be93>] ? trace_hardirqs_on+0xd/0xf
>>>>>  [ 3924.503127]  [<ffffffff81002789>] ? do_notify_resume+0x717/0x73=
d
>>>>>  [ 3924.503131]  [<ffffffff8103994e>] ? finish_task_switch+0x69/0xd=
a
>>>>>  [ 3924.503135]  [<ffffffff8110628c>] do_vfs_ioctl+0x4c3/0x50d
>>>>>  [ 3924.503139]  [<ffffffff8110632b>] sys_ioctl+0x55/0x77
>>>>>  [ 3924.503142]  [<ffffffff81002c02>] system_call_fastpath+0x16/0x1=
b
>>>>>
>>>>>  Anyone can help on this?
>>>>
>>>>  Please provide a trace (trace-cmd record -e kvm) leading to the
>>>> failure.
>>>>
>>>
>>> Hi, please see:
>>> http://userweb.kernel.org/~davey/tmp/trace.dat
>>>
>>
>> Was this done with an old version of trace-cmd?  Please use the latest=
 git.
>>  Make sure you have udis86 and udis86-devel installed when you build i=
t.
>=20
> Hi, the trace-cmd was build from git version, but without udis86.
>=20
> I updated trace.dat on the same url, is it a correct one?
>=20

IIUC, plugin_kvm is only involved in reporting, not recording, so udis86
shouldn't matter.

I had a look out of curiosity (just managed to make my trace tools work
smoothly), and the data is properly parsed by kernelshark here. There is
a strange NMI storm going on right before the triple fault (on some MSR
write) hits the fan.

Jan


>>
>> --
>> error compiling committee.c: too many arguments to function
>>
>>
>=20
>=20
>=20



--------------enigCE2CA6A11C1F714CC5C67FDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAky789AACgkQitSsb3rl5xRB/wCdEM5ZltTngMCjfT05tXmKE1Dq
En8Ani3vaw49Abpo/IIEQx2UVZuOwxEu
=P18e
-----END PGP SIGNATURE-----

--------------enigCE2CA6A11C1F714CC5C67FDE--

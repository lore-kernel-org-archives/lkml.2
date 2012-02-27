Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2B0I7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:59:13 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:36583 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2B0I7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:59:11 -0500
Message-ID: <4F4B45DB.9050006@web.de>
Date: Mon, 27 Feb 2012 09:59:07 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH]qemu: deal with guest paniced event
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4AF316.50400@cn.fujitsu.com>
In-Reply-To: <4F4AF316.50400@cn.fujitsu.com>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA2BB33408ED998A43948EF5"
X-Provags-ID: V02:K0:X/Zb4pQ8CV42+vGXKgFvs6vnxCKlVl+hTKdJVE1IKCe
 POQeHdKRkLhjf50h6SOAFhZGyjqRXBsqGvQqQxuytU0rjv9bs7
 Uv89Nb1bziIYDbbbCFPoGD2IC65pYVEpDx5IhoqHePs64eydUm
 pDpzhx8I2+pIp3dCHTk77lQhGZvmogioFEafIBUNzSsd08yKKV
 PPH/fsHqhRUI47IcARhtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA2BB33408ED998A43948EF5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-02-27 04:05, Wen Congyang wrote:
> When the host knows the guest is paniced, it will set
> exit_reason to KVM_EXIT_GUEST_PANIC. So if qemu receive
> this exit_reason, we can send a event to tell management
> application that the guest is paniced.
>=20
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c                 |    3 +++
>  linux-headers/linux/kvm.h |    1 +
>  monitor.c                 |    3 +++
>  monitor.h                 |    1 +
>  4 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/kvm-all.c b/kvm-all.c
> index c4babda..ae428ab 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -1190,6 +1190,9 @@ int kvm_cpu_exec(CPUState *env)
>                      (uint64_t)run->hw.hardware_exit_reason);
>              ret =3D -1;
>              break;
> +        case KVM_EXIT_GUEST_PANIC:
> +            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
> +            break;
>          case KVM_EXIT_INTERNAL_ERROR:
>              ret =3D kvm_handle_internal_error(env, run);
>              break;
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index f6b5343..45dd031 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -163,6 +163,7 @@ struct kvm_pit_config {
>  #define KVM_EXIT_OSI              18
>  #define KVM_EXIT_PAPR_HCALL	  19
>  #define KVM_EXIT_S390_UCONTROL	  20
> +#define KVM_EXIT_GUEST_PANIC	  21
> =20
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  #define KVM_INTERNAL_ERROR_EMULATION 1

linux-headers are supposed to be synchronized in a separate patch,
naming the upstream or kvm.git hash they pull in. IOW: the KVM ABI
change has to be applied first.

Jan


--------------enigBA2BB33408ED998A43948EF5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9LRdsACgkQitSsb3rl5xRiKQCfbgf64DlS94jkS2j5vN2sTH7o
QcIAoO/32Gu2YCA4RArhiyhe4OjHF2Fc
=vmKJ
-----END PGP SIGNATURE-----

--------------enigBA2BB33408ED998A43948EF5--

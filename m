Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2GUHZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:25:13 -0400
Received: from mout.web.de ([212.227.17.11]:61769 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2GUHZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:25:12 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2012 03:25:12 EDT
Message-ID: <500A580D.1010301@web.de>
Date: Sat, 21 Jul 2012 09:19:41 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v7] kvm: notify host when the guest is panicked
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig232B1F9952360E33B1AE00D9"
X-Provags-ID: V02:K0:vJ6xR1VBX6k0mZWDz6a6n/aw60ZUodhl5UQ62pbncwT
 kAi7E0buBsjahHE2ZdKtJIHaRCTwmMSiyg7uvMRquABUNIK/qt
 p+l/tQISeWYgo0N3mo+WKi9sHuvxoXENjHiOlRzp1cmnJvTRTu
 ifWzS3kLfy2ME2WYekcB1djnYlYCxqhWyR6Sd+3kZ7ISHxu8Qk
 oN/VPAgZoBo0caBt7XHEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig232B1F9952360E33B1AE00D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-07-21 09:12, Wen Congyang wrote:
> We can know the guest is panicked when the guest runs on xen.
> But we do not have such feature on kvm.
>=20
> Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is panicked. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is panicked.
>=20
> We have three solutions to implement this feature:
> 1. use vmcall
> 2. use I/O port
> 3. use virtio-serial.
>=20
> We have decided to avoid touching hypervisor. The reason why I choose
> choose the I/O port is:
> 1. it is easier to implememt
> 2. it does not depend any virtual device
> 3. it can work when startint the kernel
>=20
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_para.h     |    7 +++++++
>  arch/x86/kernel/kvm.c               |   14 ++++++++++++++
>  include/linux/kvm_para.h            |   13 +++++++++++++
>  6 files changed, 49 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/k=
vm_para.h
> index 2019cb9..187c0e2 100644
> --- a/arch/ia64/include/asm/kvm_para.h
> +++ b/arch/ia64/include/asm/kvm_para.h
> @@ -31,6 +31,11 @@ static inline bool kvm_check_and_clear_guest_paused(=
void)
>  	return false;
>  }
> =20
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif
> =20
>  #endif
> diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include=
/asm/kvm_para.h
> index c18916b..be81aac 100644
> --- a/arch/powerpc/include/asm/kvm_para.h
> +++ b/arch/powerpc/include/asm/kvm_para.h
> @@ -211,6 +211,11 @@ static inline bool kvm_check_and_clear_guest_pause=
d(void)
>  	return false;
>  }
> =20
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif /* __KERNEL__ */
> =20
>  #endif /* __POWERPC_KVM_PARA_H__ */
> diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/k=
vm_para.h
> index a988329..3d993b7 100644
> --- a/arch/s390/include/asm/kvm_para.h
> +++ b/arch/s390/include/asm/kvm_para.h
> @@ -154,6 +154,11 @@ static inline bool kvm_check_and_clear_guest_pause=
d(void)
>  	return false;
>  }
> =20
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return 0;
> +}
> +
>  #endif
> =20
>  #endif /* __S390_KVM_PARA_H */
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm=
_para.h
> index 63ab166..c8ad86e 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -89,6 +89,8 @@ struct kvm_vcpu_pv_apf_data {
>  	__u32 enabled;
>  };
> =20
> +#define KVM_PV_PORT	(0x505UL)
> +
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
> =20
> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>  }
>  #endif
> =20
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	return inl(KVM_PV_PORT);
> +}
> +
>  #endif /* __KERNEL__ */
> =20
>  #endif /* _ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e554e5a..9a97f7e 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -328,6 +328,17 @@ static struct notifier_block kvm_pv_reboot_nb =3D =
{
>  	.notifier_call =3D kvm_pv_reboot_notify,
>  };
> =20
> +static int
> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, voi=
d *unused)
> +{
> +	outl(KVM_PV_PANICKED, KVM_PV_PORT);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_pv_panic_nb =3D {
> +	.notifier_call =3D kvm_pv_panic_notify,
> +};
> +
>  static u64 kvm_steal_clock(int cpu)
>  {
>  	u64 steal;
> @@ -414,6 +425,9 @@ void __init kvm_guest_init(void)
> =20
>  	paravirt_ops_setup();
>  	register_reboot_notifier(&kvm_pv_reboot_nb);
> +	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +			&kvm_pv_panic_nb);
>  	for (i =3D 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>  		spin_lock_init(&async_pf_sleepers[i].lock);
>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> index ff476dd..e73efcf 100644
> --- a/include/linux/kvm_para.h
> +++ b/include/linux/kvm_para.h
> @@ -20,6 +20,12 @@
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> =20
> +/* The bit of the value read from KVM_PV_PORT */
> +#define KVM_PV_FEATURE_PANICKED	0
> +
> +/* The value writen to KVM_PV_PORT */
> +#define KVM_PV_PANICKED		1
> +
>  /*
>   * hypercalls use architecture specific
>   */
> @@ -33,5 +39,12 @@ static inline int kvm_para_has_feature(unsigned int =
feature)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int kvm_pv_has_feature(unsigned int feature)
> +{
> +	if (kvm_arch_pv_features() & (1UL << feature))

Reading from an invalid I/O port will return -1. So your test will
deliver a wrong result on a platform that doesn't support this PV channel=
=2E

Jan

> +		return 1;
> +	return 0;
> +}
>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_KVM_PARA_H */
>=20





--------------enig232B1F9952360E33B1AE00D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAKWA0ACgkQitSsb3rl5xThvQCffQjfmpBHXT83smD0FOH31WM2
7TwAnjsvqFODU0wCi4LL/VUm8rV0e4jF
=XfGT
-----END PGP SIGNATURE-----

--------------enig232B1F9952360E33B1AE00D9--

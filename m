Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2F1Iyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:54:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:31027 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2F1Iyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:54:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="txt'?scan'208";a="163875263"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "Auld, Will" <will.auld@intel.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [xen vMCE RFC V0.2] xen vMCE design
Thread-Topic: [xen vMCE RFC V0.2] xen vMCE design
Thread-Index: AQHNVGbW1l9vq4iTRyWE8p2SJy8j95cPaWDw
Date: Thu, 28 Jun 2012 08:54:40 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
In-Reply-To: <4FEB236C020000780008C392@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335263B9DSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335263B9DSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jan Beulich wrote:
>>>> On 27.06.12 at 05:51, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> This is updated xen vMCE design foils, according to comments from
>> community recently.=20
>>=20
>> This foils focus on vMCE part of Xen MCA, so as Keir said, it's some
>> dense. Later Will will present a document to elaborate more,
>> including Intel MCA and surrounding features and Xen implementation.
>=20
> For MCi_CTL2 you probably meant to say "allow setting CMCI_EN
> and error count threshold"?

Yes, exactly! the words is w/ subtle but important different meaning.

>=20
> The 2-bank approach also needs to be brought in line with the
> current host derived value in MCG_CAP, especially if the code to
> implement this new model doesn't make it into 4.2 (which would
> generally save a larger value).
>=20
> Jan

Let me repeat in my word to avoid misunderstanding about your concern:
Your concern rooted from the history patch (c/s 24887, as attached) which u=
sed to solve vMCE migration issue caused from bank number. I guess the patc=
h was not in xen4.1.x but would be in xen 4.2 release recently (right? and =
when will xen 4.2 release?)
Per my understanding, you want us to make sure our new vMCE model compatibl=
e w/ olde vMCE. For example if our patch in xen 4.3 release, you want to ma=
ke sure a guest migrate from xen 4.2 to 4.3 would not broken. Is this your =
concern?

Thanks,
Jinsong=

--_002_DE8DF0795D48FD4CA783C40EC8292335263B9DSHSMSX101ccrcorpi_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 28 Jun 2012 08:54:39 GMT";
	modification-date="Thu, 28 Jun 2012 08:54:39 GMT"

Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 SHSMSX151.ccr.corp.intel.com (10.239.6.50) with Microsoft SMTP Server (TLS)
 id 14.1.355.2; Wed, 15 Feb 2012 19:04:26 +0800
Received: from fmsmsx108.amr.corp.intel.com (10.19.9.228) by
 SHSMSX101.ccr.corp.intel.com (10.239.4.153) with Microsoft SMTP Server (TLS)
 id 14.1.355.2; Wed, 15 Feb 2012 19:04:25 +0800
Received: from rrsmsx601.amr.corp.intel.com (10.31.0.151) by
 FMSMSX108.amr.corp.intel.com (10.19.9.228) with Microsoft SMTP Server (TLS)
 id 14.1.355.2; Wed, 15 Feb 2012 03:04:24 -0800
Received: from azsmga001.ch.intel.com (10.2.17.19) by rrsmsx601-1.rr.intel.com
 (10.31.0.151) with Microsoft SMTP Server id 8.2.255.0; Wed, 15 Feb 2012
 04:03:48 -0700
Received: from azsmga102.ch.intel.com ([10.2.16.52])  by
 azsmga001-1.ch.intel.com with ESMTP; 15 Feb 2012 03:03:46 -0800
Received: from lists.xen.org ([50.57.142.19])  by mga14.intel.com with ESMTP;
 15 Feb 2012 03:03:44 -0800
Received: from localhost ([127.0.0.1] helo=lists.xen.org)	by lists.xen.org
 with esmtp (Exim 4.72)	(envelope-from
 <xen-devel-bounces@lists.xensource.com>)	id 1Rxcbo-0008F8-C8; Wed, 15 Feb
 2012 11:01:12 +0000
Received: from mail174.messagelabs.com ([85.158.138.51])	by lists.xen.org with
 esmtp (Exim 4.72)	(envelope-from <JBeulich@suse.com>) id 1Rxcbm-0008EN-Ur	for
 xen-devel@lists.xensource.com; Wed, 15 Feb 2012 11:01:11 +0000
Received: (qmail 24767 invoked from network); 15 Feb 2012 11:01:03 -0000
Received: from nat28.tlf.novell.com (HELO nat28.tlf.novell.com) (130.57.49.28)
	by server-13.tower-174.messagelabs.com with DHE-RSA-AES256-SHA	encrypted
 SMTP; 15 Feb 2012 11:01:03 -0000
Received: from EMEA1-MTA by nat28.tlf.novell.com	with Novell_GroupWise; Wed,
 15 Feb 2012 11:01:04 +0000
From: Jan Beulich <JBeulich@suse.com>
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: Olaf Hering <olaf@aepfle.de>
Subject: [Xen-devel] [PATCH 2/2] x86/vMCE: save/restore MCA capabilities
Thread-Topic: [Xen-devel] [PATCH 2/2] x86/vMCE: save/restore MCA capabilities
Thread-Index: AQHM69GUIaRbcUEjU0SZ9CYw3vbbqA==
Sender: "xen-devel-bounces@lists.xensource.com"
	<xen-devel-bounces@lists.xensource.com>
Date: Wed, 15 Feb 2012 11:01:02 +0000
Message-ID: <4F3B9E7E0200007800073218@nat28.tlf.novell.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
List-Unsubscribe: <http://lists.xensource.com/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: rrsmsx601.amr.corp.intel.com
X-MS-Has-Attach: yes
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.71,315,1320652800";
    d="scan'208";a="794129760"
x-mailman-version: 2.1.13
errors-to: xen-devel-bounces@lists.xensource.com
x-ironport-anti-spam-filtered: true
x-ironport-anti-spam-result: AgcBAAjU304yOY4TmWdsb2JhbAAtFoIFqFEiAQEBAQEICwsHFB4HgXQGAQEMAQoNHwoeCwMDAQIGAjUPBAgDASQ1EwWIBAakPQGSN4d0gl1jBIx0KAF1hDWCJJIj
x-env-sender: JBeulich@suse.com
x-originating-ip: [130.57.49.28]
x-msg-ref: server-13.tower-174.messagelabs.com!1329303662!8301262!1
x-viruschecked: Checked
x-starscan-version: 6.5.5; banners=-,-,-
x-beenthere: xen-devel@lists.xensource.com
list-id: Xen developer discussion <xen-devel.lists.xensource.com>
list-post: <mailto:xen-devel@lists.xensource.com>
x-spamreason: No, hits=0.5 required=7.0 tests=BODY_RANDOM_LONG
Content-Type: multipart/mixed;
	boundary="_003_4F3B9E7E0200007800073218nat28tlfnovellcom_"
MIME-Version: 1.0

--_003_4F3B9E7E0200007800073218nat28tlfnovellcom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8AB1E9C344A8F84FB012A9ADB2E5E536@intel.com>
Content-Transfer-Encoding: quoted-printable

This allows migration to a host with less MCA banks than the source
host had, while without this patch accesses to the excess banks' MSRs
caused #GP-s in the guest after migration (and it depended on the guest
kernel whether this would be fatal).

A fundamental question is whether we should also save/restore MCG_CTL
and MCi_CTL, as the HVM save record would better be defined to the
complete state that needs saving from the beginning (I'm unsure whether
the save/restore logic allows for future extension of an existing
record).

Of course, this change is expected to make migration from new to older
Xen impossible (again I'm unsure what the save/restore logic does with
records it doesn't even know about).

The (trivial) tools side change may seem unrelated, but the code should
have been that way from the beginning to allow the hypervisor to look
at currently unused ext_vcpucontext fields without risking to read
garbage when those fields get a meaning assigned in the future. This
isn't being enforced here - should it be? (Obviously, for backwards
compatibility, the hypervisor must assume these fields to be clear only
when the extended context's size exceeds the old original one.)

A future addition to this change might be to allow configuration of the
number of banks and other MCA capabilities for a guest before it starts
(i.e. to not inherits the values seen on the first host it runs on).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/tools/libxc/xc_domain_save.c
+++ b/tools/libxc/xc_domain_save.c
@@ -1879,6 +1879,7 @@ int xc_domain_save(xc_interface *xch, in
=20
         domctl.cmd =3D XEN_DOMCTL_get_ext_vcpucontext;
         domctl.domain =3D dom;
+        memset(&domctl.u, 0, sizeof(domctl.u));
         domctl.u.ext_vcpucontext.vcpu =3D i;
         if ( xc_domctl(xch, &domctl) < 0 )
         {
--- a/tools/misc/xen-hvmctx.c
+++ b/tools/misc/xen-hvmctx.c
@@ -383,6 +383,13 @@ static void dump_viridian_vcpu(void)
            (unsigned long long) p.apic_assist);          =20
 }
=20
+static void dump_vmce_vcpu(void)
+{
+    HVM_SAVE_TYPE(VMCE_VCPU) p;
+    READ(p);
+    printf("    VMCE_VCPU: caps %" PRIx64 "\n", p.caps);
+}
+
 int main(int argc, char **argv)
 {
     int entry, domid;
@@ -449,6 +456,7 @@ int main(int argc, char **argv)
         case HVM_SAVE_CODE(MTRR): dump_mtrr(); break;
         case HVM_SAVE_CODE(VIRIDIAN_DOMAIN): dump_viridian_domain(); break=
;
         case HVM_SAVE_CODE(VIRIDIAN_VCPU): dump_viridian_vcpu(); break;
+        case HVM_SAVE_CODE(VMCE_VCPU): dump_vmce_vcpu(); break;
         case HVM_SAVE_CODE(END): break;
         default:
             printf(" ** Don't understand type %u: skipping\n",
--- a/xen/arch/x86/cpu/mcheck/mce.h
+++ b/xen/arch/x86/cpu/mcheck/mce.h
@@ -3,6 +3,7 @@
 #define _MCE_H
=20
 #include <xen/init.h>
+#include <xen/sched.h>
 #include <xen/smp.h>
 #include <asm/types.h>
 #include <asm/traps.h>
@@ -54,8 +55,8 @@ int unmmap_broken_page(struct domain *d,
 u64 mce_cap_init(void);
 extern unsigned int firstbank;
=20
-int intel_mce_rdmsr(uint32_t msr, uint64_t *val);
-int intel_mce_wrmsr(uint32_t msr, uint64_t val);
+int intel_mce_rdmsr(const struct vcpu *, uint32_t msr, uint64_t *val);
+int intel_mce_wrmsr(struct vcpu *, uint32_t msr, uint64_t val);
=20
 struct mcinfo_extended *intel_get_extended_msrs(
     struct mcinfo_global *mig, struct mc_info *mi);
@@ -171,18 +172,20 @@ int vmce_domain_inject(struct mcinfo_ban
=20
 extern int vmce_init(struct cpuinfo_x86 *c);
=20
-static inline int mce_vendor_bank_msr(uint32_t msr)
+static inline int mce_vendor_bank_msr(const struct vcpu *v, uint32_t msr)
 {
     if ( boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_INTEL &&
-         msr >=3D MSR_IA32_MC0_CTL2 && msr < (MSR_IA32_MC0_CTL2 + nr_mce_b=
anks) )
+         msr >=3D MSR_IA32_MC0_CTL2 &&
+         msr < MSR_IA32_MCx_CTL2(v->arch.mcg_cap & MCG_CAP_COUNT) )
           return 1;
     return 0;
 }
=20
-static inline int mce_bank_msr(uint32_t msr)
+static inline int mce_bank_msr(const struct vcpu *v, uint32_t msr)
 {
-    if ( (msr >=3D MSR_IA32_MC0_CTL && msr < MSR_IA32_MCx_CTL(nr_mce_banks=
)) ||
-        mce_vendor_bank_msr(msr) )
+    if ( (msr >=3D MSR_IA32_MC0_CTL &&
+          msr < MSR_IA32_MCx_CTL(v->arch.mcg_cap & MCG_CAP_COUNT)) ||
+         mce_vendor_bank_msr(v, msr) )
         return 1;
     return 0;
 }
--- a/xen/arch/x86/cpu/mcheck/mce_intel.c
+++ b/xen/arch/x86/cpu/mcheck/mce_intel.c
@@ -1421,11 +1421,12 @@ enum mcheck_type intel_mcheck_init(struc
 }
=20
 /* intel specific MCA MSR */
-int intel_mce_wrmsr(uint32_t msr, uint64_t val)
+int intel_mce_wrmsr(struct vcpu *v, uint32_t msr, uint64_t val)
 {
     int ret =3D 0;
=20
-    if (msr >=3D MSR_IA32_MC0_CTL2 && msr < (MSR_IA32_MC0_CTL2 + nr_mce_ba=
nks))
+    if ( msr >=3D MSR_IA32_MC0_CTL2 &&
+         msr < MSR_IA32_MCx_CTL2(v->arch.mcg_cap & MCG_CAP_COUNT) )
     {
         mce_printk(MCE_QUIET, "We have disabled CMCI capability, "
                  "Guest should not write this MSR!\n");
@@ -1435,11 +1436,12 @@ int intel_mce_wrmsr(uint32_t msr, uint64
     return ret;
 }
=20
-int intel_mce_rdmsr(uint32_t msr, uint64_t *val)
+int intel_mce_rdmsr(const struct vcpu *v, uint32_t msr, uint64_t *val)
 {
     int ret =3D 0;
=20
-    if (msr >=3D MSR_IA32_MC0_CTL2 && msr < (MSR_IA32_MC0_CTL2 + nr_mce_ba=
nks))
+    if ( msr >=3D MSR_IA32_MC0_CTL2 &&
+         msr < MSR_IA32_MCx_CTL2(v->arch.mcg_cap & MCG_CAP_COUNT) )
     {
         mce_printk(MCE_QUIET, "We have disabled CMCI capability, "
                  "Guest should not read this MSR!\n");
--- a/xen/arch/x86/cpu/mcheck/vmce.c
+++ b/xen/arch/x86/cpu/mcheck/vmce.c
@@ -10,6 +10,7 @@
 #include <xen/delay.h>
 #include <xen/smp.h>
 #include <xen/mm.h>
+#include <xen/hvm/save.h>
 #include <asm/processor.h>
 #include <public/sysctl.h>
 #include <asm/system.h>
@@ -42,7 +43,6 @@ int vmce_init_msr(struct domain *d)
            nr_mce_banks * sizeof(*dom_vmce(d)->mci_ctl));
=20
     dom_vmce(d)->mcg_status =3D 0x0;
-    dom_vmce(d)->mcg_cap =3D g_mcg_cap;
     dom_vmce(d)->mcg_ctl =3D ~(uint64_t)0x0;
     dom_vmce(d)->nr_injection =3D 0;
=20
@@ -61,21 +61,41 @@ void vmce_destroy_msr(struct domain *d)
     dom_vmce(d) =3D NULL;
 }
=20
-static int bank_mce_rdmsr(struct domain *d, uint32_t msr, uint64_t *val)
+void vmce_init_vcpu(struct vcpu *v)
 {
-    int bank, ret =3D 1;
-    struct domain_mca_msrs *vmce =3D dom_vmce(d);
+    v->arch.mcg_cap =3D g_mcg_cap;
+}
+
+int vmce_restore_vcpu(struct vcpu *v, uint64_t caps)
+{
+    if ( caps & ~g_mcg_cap & ~MCG_CAP_COUNT & ~MCG_CTL_P )
+    {
+        dprintk(XENLOG_G_ERR, "%s restore: unsupported MCA capabilities"
+                " %#" PRIx64 " for d%d:v%u (supported: %#Lx)\n",
+                is_hvm_vcpu(v) ? "HVM" : "PV", caps, v->domain->domain_id,
+                v->vcpu_id, g_mcg_cap & ~MCG_CAP_COUNT);
+        return -EPERM;
+    }
+
+    v->arch.mcg_cap =3D caps;
+    return 0;
+}
+
+static int bank_mce_rdmsr(const struct vcpu *v, uint32_t msr, uint64_t *va=
l)
+{
+    int ret =3D 1;
+    unsigned int bank =3D (msr - MSR_IA32_MC0_CTL) / 4;
+    struct domain_mca_msrs *vmce =3D dom_vmce(v->domain);
     struct bank_entry *entry;
=20
-    bank =3D (msr - MSR_IA32_MC0_CTL) / 4;
-    if ( bank >=3D nr_mce_banks )
-        return -1;
+    *val =3D 0;
=20
     switch ( msr & (MSR_IA32_MC0_CTL | 3) )
     {
     case MSR_IA32_MC0_CTL:
-        *val =3D vmce->mci_ctl[bank] &
-            (h_mci_ctrl ? h_mci_ctrl[bank] : ~0UL);
+        if ( bank < nr_mce_banks )
+            *val =3D vmce->mci_ctl[bank] &
+                   (h_mci_ctrl ? h_mci_ctrl[bank] : ~0UL);
         mce_printk(MCE_VERBOSE, "MCE: rdmsr MC%u_CTL 0x%"PRIx64"\n",
                    bank, *val);
         break;
@@ -126,7 +146,7 @@ static int bank_mce_rdmsr(struct domain=20
         switch ( boot_cpu_data.x86_vendor )
         {
         case X86_VENDOR_INTEL:
-            ret =3D intel_mce_rdmsr(msr, val);
+            ret =3D intel_mce_rdmsr(v, msr, val);
             break;
         default:
             ret =3D 0;
@@ -145,13 +165,13 @@ static int bank_mce_rdmsr(struct domain=20
  */
 int vmce_rdmsr(uint32_t msr, uint64_t *val)
 {
-    struct domain *d =3D current->domain;
-    struct domain_mca_msrs *vmce =3D dom_vmce(d);
+    const struct vcpu *cur =3D current;
+    struct domain_mca_msrs *vmce =3D dom_vmce(cur->domain);
     int ret =3D 1;
=20
     *val =3D 0;
=20
-    spin_lock(&dom_vmce(d)->lock);
+    spin_lock(&vmce->lock);
=20
     switch ( msr )
     {
@@ -162,39 +182,38 @@ int vmce_rdmsr(uint32_t msr, uint64_t *v
                        "MCE: rdmsr MCG_STATUS 0x%"PRIx64"\n", *val);
         break;
     case MSR_IA32_MCG_CAP:
-        *val =3D vmce->mcg_cap;
+        *val =3D cur->arch.mcg_cap;
         mce_printk(MCE_VERBOSE, "MCE: rdmsr MCG_CAP 0x%"PRIx64"\n",
                    *val);
         break;
     case MSR_IA32_MCG_CTL:
         /* Always 0 if no CTL support */
-        *val =3D vmce->mcg_ctl & h_mcg_ctl;
+        if ( cur->arch.mcg_cap & MCG_CTL_P )
+            *val =3D vmce->mcg_ctl & h_mcg_ctl;
         mce_printk(MCE_VERBOSE, "MCE: rdmsr MCG_CTL 0x%"PRIx64"\n",
                    *val);
         break;
     default:
-        ret =3D mce_bank_msr(msr) ? bank_mce_rdmsr(d, msr, val) : 0;
+        ret =3D mce_bank_msr(cur, msr) ? bank_mce_rdmsr(cur, msr, val) : 0=
;
         break;
     }
=20
-    spin_unlock(&dom_vmce(d)->lock);
+    spin_unlock(&vmce->lock);
     return ret;
 }
=20
-static int bank_mce_wrmsr(struct domain *d, u32 msr, u64 val)
+static int bank_mce_wrmsr(struct vcpu *v, u32 msr, u64 val)
 {
-    int bank, ret =3D 1;
-    struct domain_mca_msrs *vmce =3D dom_vmce(d);
+    int ret =3D 1;
+    unsigned int bank =3D (msr - MSR_IA32_MC0_CTL) / 4;
+    struct domain_mca_msrs *vmce =3D dom_vmce(v->domain);
     struct bank_entry *entry =3D NULL;
=20
-    bank =3D (msr - MSR_IA32_MC0_CTL) / 4;
-    if ( bank >=3D nr_mce_banks )
-        return -EINVAL;
-
     switch ( msr & (MSR_IA32_MC0_CTL | 3) )
     {
     case MSR_IA32_MC0_CTL:
-        vmce->mci_ctl[bank] =3D val;
+        if ( bank < nr_mce_banks )
+            vmce->mci_ctl[bank] =3D val;
         break;
     case MSR_IA32_MC0_STATUS:
         /* Give the first entry of the list, it corresponds to current
@@ -202,9 +221,9 @@ static int bank_mce_wrmsr(struct domain=20
          * the guest, this node will be deleted.
          * Only error bank is written. Non-error banks simply return.
          */
-        if ( !list_empty(&dom_vmce(d)->impact_header) )
+        if ( !list_empty(&vmce->impact_header) )
         {
-            entry =3D list_entry(dom_vmce(d)->impact_header.next,
+            entry =3D list_entry(vmce->impact_header.next,
                                struct bank_entry, list);
             if ( entry->bank =3D=3D bank )
                 entry->mci_status =3D val;
@@ -228,7 +247,7 @@ static int bank_mce_wrmsr(struct domain=20
         switch ( boot_cpu_data.x86_vendor )
         {
         case X86_VENDOR_INTEL:
-            ret =3D intel_mce_wrmsr(msr, val);
+            ret =3D intel_mce_wrmsr(v, msr, val);
             break;
         default:
             ret =3D 0;
@@ -247,9 +266,9 @@ static int bank_mce_wrmsr(struct domain=20
  */
 int vmce_wrmsr(u32 msr, u64 val)
 {
-    struct domain *d =3D current->domain;
+    struct vcpu *cur =3D current;
     struct bank_entry *entry =3D NULL;
-    struct domain_mca_msrs *vmce =3D dom_vmce(d);
+    struct domain_mca_msrs *vmce =3D dom_vmce(cur->domain);
     int ret =3D 1;
=20
     if ( !g_mcg_cap )
@@ -266,7 +285,7 @@ int vmce_wrmsr(u32 msr, u64 val)
         vmce->mcg_status =3D val;
         mce_printk(MCE_VERBOSE, "MCE: wrmsr MCG_STATUS %"PRIx64"\n", val);
         /* For HVM guest, this is the point for deleting vMCE injection no=
de */
-        if ( d->is_hvm && (vmce->nr_injection > 0) )
+        if ( is_hvm_vcpu(cur) && (vmce->nr_injection > 0) )
         {
             vmce->nr_injection--; /* Should be 0 */
             if ( !list_empty(&vmce->impact_header) )
@@ -293,7 +312,7 @@ int vmce_wrmsr(u32 msr, u64 val)
         ret =3D -1;
         break;
     default:
-        ret =3D mce_bank_msr(msr) ? bank_mce_wrmsr(d, msr, val) : 0;
+        ret =3D mce_bank_msr(cur, msr) ? bank_mce_wrmsr(cur, msr, val) : 0=
;
         break;
     }
=20
@@ -301,6 +320,46 @@ int vmce_wrmsr(u32 msr, u64 val)
     return ret;
 }
=20
+static int vmce_save_vcpu_ctxt(struct domain *d, hvm_domain_context_t *h)
+{
+    struct vcpu *v;
+    int err =3D 0;
+
+    for_each_vcpu( d, v ) {
+        struct hvm_vmce_vcpu ctxt =3D {
+            .caps =3D v->arch.mcg_cap
+        };
+
+        err =3D hvm_save_entry(VMCE_VCPU, v->vcpu_id, h, &ctxt);
+        if ( err )
+            break;
+    }
+
+    return err;
+}
+
+static int vmce_load_vcpu_ctxt(struct domain *d, hvm_domain_context_t *h)
+{
+    unsigned int vcpuid =3D hvm_load_instance(h);
+    struct vcpu *v;
+    struct hvm_vmce_vcpu ctxt;
+    int err;
+
+    if ( vcpuid >=3D d->max_vcpus || (v =3D d->vcpu[vcpuid]) =3D=3D NULL )
+    {
+        dprintk(XENLOG_G_ERR, "HVM restore: dom%d has no vcpu%u\n",
+                d->domain_id, vcpuid);
+        err =3D -EINVAL;
+    }
+    else
+        err =3D hvm_load_entry(VMCE_VCPU, h, &ctxt);
+
+    return err ?: vmce_restore_vcpu(v, ctxt.caps);
+}
+
+HVM_REGISTER_SAVE_RESTORE(VMCE_VCPU, vmce_save_vcpu_ctxt,
+                          vmce_load_vcpu_ctxt, 1, HVMSR_PER_VCPU);
+
 int inject_vmce(struct domain *d)
 {
     int cpu =3D smp_processor_id();
--- a/xen/arch/x86/domain.c
+++ b/xen/arch/x86/domain.c
@@ -422,6 +422,8 @@ int vcpu_initialise(struct vcpu *v)
     if ( (rc =3D vcpu_init_fpu(v)) !=3D 0 )
         return rc;
=20
+    vmce_init_vcpu(v);
+
     if ( is_hvm_domain(d) )
     {
         rc =3D hvm_vcpu_initialise(v);
--- a/xen/arch/x86/domctl.c
+++ b/xen/arch/x86/domctl.c
@@ -1027,11 +1027,12 @@ long arch_do_domctl(
                 evc->syscall32_callback_eip    =3D 0;
                 evc->syscall32_disables_events =3D 0;
             }
+            evc->mcg_cap =3D v->arch.mcg_cap;
         }
         else
         {
             ret =3D -EINVAL;
-            if ( evc->size !=3D sizeof(*evc) )
+            if ( evc->size < offsetof(typeof(*evc), mcg_cap) )
                 goto ext_vcpucontext_out;
 #ifdef __x86_64__
             if ( !is_hvm_domain(d) )
@@ -1059,6 +1060,10 @@ long arch_do_domctl(
                  (evc->syscall32_callback_cs & ~3) ||
                  evc->syscall32_callback_eip )
                 goto ext_vcpucontext_out;
+
+            if ( evc->size >=3D offsetof(typeof(*evc), mcg_cap) +
+                              sizeof(evc->mcg_cap) )
+                ret =3D vmce_restore_vcpu(v, evc->mcg_cap);
         }
=20
         ret =3D 0;
--- a/xen/include/asm-x86/domain.h
+++ b/xen/include/asm-x86/domain.h
@@ -488,6 +488,8 @@ struct arch_vcpu
     /* This variable determines whether nonlazy extended state has been us=
ed,
      * and thus should be saved/restored. */
     bool_t nonlazy_xstate_used;
+
+    uint64_t mcg_cap;
    =20
     struct paging_vcpu paging;
=20
--- a/xen/include/asm-x86/mce.h
+++ b/xen/include/asm-x86/mce.h
@@ -16,7 +16,6 @@ struct bank_entry {
 struct domain_mca_msrs
 {
     /* Guest should not change below values after DOM boot up */
-    uint64_t mcg_cap;
     uint64_t mcg_ctl;
     uint64_t mcg_status;
     uint64_t *mci_ctl;
@@ -28,6 +27,8 @@ struct domain_mca_msrs
 /* Guest vMCE MSRs virtualization */
 extern int vmce_init_msr(struct domain *d);
 extern void vmce_destroy_msr(struct domain *d);
+extern void vmce_init_vcpu(struct vcpu *);
+extern int vmce_restore_vcpu(struct vcpu *, uint64_t caps);
 extern int vmce_wrmsr(uint32_t msr, uint64_t val);
 extern int vmce_rdmsr(uint32_t msr, uint64_t *val);
=20
--- a/xen/include/public/arch-x86/hvm/save.h
+++ b/xen/include/public/arch-x86/hvm/save.h
@@ -585,9 +585,15 @@ struct hvm_viridian_vcpu_context {
=20
 DECLARE_HVM_SAVE_TYPE(VIRIDIAN_VCPU, 17, struct hvm_viridian_vcpu_context)=
;
=20
+struct hvm_vmce_vcpu {
+    uint64_t caps;
+};
+
+DECLARE_HVM_SAVE_TYPE(VMCE_VCPU, 18, struct hvm_vmce_vcpu);
+
 /*=20
  * Largest type-code in use
  */
-#define HVM_SAVE_CODE_MAX 17
+#define HVM_SAVE_CODE_MAX 18
=20
 #endif /* __XEN_PUBLIC_HVM_SAVE_X86_H__ */
--- a/xen/include/public/domctl.h
+++ b/xen/include/public/domctl.h
@@ -559,7 +559,7 @@ struct xen_domctl_ext_vcpucontext {
     uint32_t         vcpu;
     /*
      * SET: Size of struct (IN)
-     * GET: Size of struct (OUT)
+     * GET: Size of struct (OUT, up to 128 bytes)
      */
     uint32_t         size;
 #if defined(__i386__) || defined(__x86_64__)
@@ -571,6 +571,7 @@ struct xen_domctl_ext_vcpucontext {
     uint16_t         sysenter_callback_cs;
     uint8_t          syscall32_disables_events;
     uint8_t          sysenter_disables_events;
+    uint64_aligned_t mcg_cap;
 #endif
 };
 typedef struct xen_domctl_ext_vcpucontext xen_domctl_ext_vcpucontext_t;



--_003_4F3B9E7E0200007800073218nat28tlfnovellcom_
Content-Type: text/plain; name="x86-vmce-sr.patch"
Content-Description: x86-vmce-sr.patch
Content-Disposition: attachment; filename="x86-vmce-sr.patch"; size=16665;
	creation-date="Wed, 15 Feb 2012 11:04:26 GMT";
	modification-date="Wed, 15 Feb 2012 11:04:26 GMT"
Content-ID: <D3C3E22374CA4A47B197E04B09C1C586@intel.com>
Content-Transfer-Encoding: base64

eDg2L3ZNQ0U6IHNhdmUvcmVzdG9yZSBNQ0EgY2FwYWJpbGl0aWVzCgpUaGlzIGFsbG93cyBtaWdy
YXRpb24gdG8gYSBob3N0IHdpdGggbGVzcyBNQ0EgYmFua3MgdGhhbiB0aGUgc291cmNlCmhvc3Qg
aGFkLCB3aGlsZSB3aXRob3V0IHRoaXMgcGF0Y2ggYWNjZXNzZXMgdG8gdGhlIGV4Y2VzcyBiYW5r
cycgTVNScwpjYXVzZWQgI0dQLXMgaW4gdGhlIGd1ZXN0IGFmdGVyIG1pZ3JhdGlvbiAoYW5kIGl0
IGRlcGVuZGVkIG9uIHRoZSBndWVzdAprZXJuZWwgd2hldGhlciB0aGlzIHdvdWxkIGJlIGZhdGFs
KS4KCkEgZnVuZGFtZW50YWwgcXVlc3Rpb24gaXMgd2hldGhlciB3ZSBzaG91bGQgYWxzbyBzYXZl
L3Jlc3RvcmUgTUNHX0NUTAphbmQgTUNpX0NUTCwgYXMgdGhlIEhWTSBzYXZlIHJlY29yZCB3b3Vs
ZCBiZXR0ZXIgYmUgZGVmaW5lZCB0byB0aGUKY29tcGxldGUgc3RhdGUgdGhhdCBuZWVkcyBzYXZp
bmcgZnJvbSB0aGUgYmVnaW5uaW5nIChJJ20gdW5zdXJlIHdoZXRoZXIKdGhlIHNhdmUvcmVzdG9y
ZSBsb2dpYyBhbGxvd3MgZm9yIGZ1dHVyZSBleHRlbnNpb24gb2YgYW4gZXhpc3RpbmcKcmVjb3Jk
KS4KCk9mIGNvdXJzZSwgdGhpcyBjaGFuZ2UgaXMgZXhwZWN0ZWQgdG8gbWFrZSBtaWdyYXRpb24g
ZnJvbSBuZXcgdG8gb2xkZXIKWGVuIGltcG9zc2libGUgKGFnYWluIEknbSB1bnN1cmUgd2hhdCB0
aGUgc2F2ZS9yZXN0b3JlIGxvZ2ljIGRvZXMgd2l0aApyZWNvcmRzIGl0IGRvZXNuJ3QgZXZlbiBr
bm93IGFib3V0KS4KClRoZSAodHJpdmlhbCkgdG9vbHMgc2lkZSBjaGFuZ2UgbWF5IHNlZW0gdW5y
ZWxhdGVkLCBidXQgdGhlIGNvZGUgc2hvdWxkCmhhdmUgYmVlbiB0aGF0IHdheSBmcm9tIHRoZSBi
ZWdpbm5pbmcgdG8gYWxsb3cgdGhlIGh5cGVydmlzb3IgdG8gbG9vawphdCBjdXJyZW50bHkgdW51
c2VkIGV4dF92Y3B1Y29udGV4dCBmaWVsZHMgd2l0aG91dCByaXNraW5nIHRvIHJlYWQKZ2FyYmFn
ZSB3aGVuIHRob3NlIGZpZWxkcyBnZXQgYSBtZWFuaW5nIGFzc2lnbmVkIGluIHRoZSBmdXR1cmUu
IFRoaXMKaXNuJ3QgYmVpbmcgZW5mb3JjZWQgaGVyZSAtIHNob3VsZCBpdCBiZT8gKE9idmlvdXNs
eSwgZm9yIGJhY2t3YXJkcwpjb21wYXRpYmlsaXR5LCB0aGUgaHlwZXJ2aXNvciBtdXN0IGFzc3Vt
ZSB0aGVzZSBmaWVsZHMgdG8gYmUgY2xlYXIgb25seQp3aGVuIHRoZSBleHRlbmRlZCBjb250ZXh0
J3Mgc2l6ZSBleGNlZWRzIHRoZSBvbGQgb3JpZ2luYWwgb25lLikKCkEgZnV0dXJlIGFkZGl0aW9u
IHRvIHRoaXMgY2hhbmdlIG1pZ2h0IGJlIHRvIGFsbG93IGNvbmZpZ3VyYXRpb24gb2YgdGhlCm51
bWJlciBvZiBiYW5rcyBhbmQgb3RoZXIgTUNBIGNhcGFiaWxpdGllcyBmb3IgYSBndWVzdCBiZWZv
cmUgaXQgc3RhcnRzCihpLmUuIHRvIG5vdCBpbmhlcml0cyB0aGUgdmFsdWVzIHNlZW4gb24gdGhl
IGZpcnN0IGhvc3QgaXQgcnVucyBvbikuCgpTaWduZWQtb2ZmLWJ5OiBKYW4gQmV1bGljaCA8amJl
dWxpY2hAc3VzZS5jb20+CgotLS0gYS90b29scy9saWJ4Yy94Y19kb21haW5fc2F2ZS5jCisrKyBi
L3Rvb2xzL2xpYnhjL3hjX2RvbWFpbl9zYXZlLmMKQEAgLTE4NzksNiArMTg3OSw3IEBAIGludCB4
Y19kb21haW5fc2F2ZSh4Y19pbnRlcmZhY2UgKnhjaCwgaW4KIAogICAgICAgICBkb21jdGwuY21k
ID0gWEVOX0RPTUNUTF9nZXRfZXh0X3ZjcHVjb250ZXh0OwogICAgICAgICBkb21jdGwuZG9tYWlu
ID0gZG9tOworICAgICAgICBtZW1zZXQoJmRvbWN0bC51LCAwLCBzaXplb2YoZG9tY3RsLnUpKTsK
ICAgICAgICAgZG9tY3RsLnUuZXh0X3ZjcHVjb250ZXh0LnZjcHUgPSBpOwogICAgICAgICBpZiAo
IHhjX2RvbWN0bCh4Y2gsICZkb21jdGwpIDwgMCApCiAgICAgICAgIHsKLS0tIGEvdG9vbHMvbWlz
Yy94ZW4taHZtY3R4LmMKKysrIGIvdG9vbHMvbWlzYy94ZW4taHZtY3R4LmMKQEAgLTM4Myw2ICsz
ODMsMTMgQEAgc3RhdGljIHZvaWQgZHVtcF92aXJpZGlhbl92Y3B1KHZvaWQpCiAgICAgICAgICAg
ICh1bnNpZ25lZCBsb25nIGxvbmcpIHAuYXBpY19hc3Npc3QpOyAgICAgICAgICAgCiB9CiAKK3N0
YXRpYyB2b2lkIGR1bXBfdm1jZV92Y3B1KHZvaWQpCit7CisgICAgSFZNX1NBVkVfVFlQRShWTUNF
X1ZDUFUpIHA7CisgICAgUkVBRChwKTsKKyAgICBwcmludGYoIiAgICBWTUNFX1ZDUFU6IGNhcHMg
JSIgUFJJeDY0ICJcbiIsIHAuY2Fwcyk7Cit9CisKIGludCBtYWluKGludCBhcmdjLCBjaGFyICoq
YXJndikKIHsKICAgICBpbnQgZW50cnksIGRvbWlkOwpAQCAtNDQ5LDYgKzQ1Niw3IEBAIGludCBt
YWluKGludCBhcmdjLCBjaGFyICoqYXJndikKICAgICAgICAgY2FzZSBIVk1fU0FWRV9DT0RFKE1U
UlIpOiBkdW1wX210cnIoKTsgYnJlYWs7CiAgICAgICAgIGNhc2UgSFZNX1NBVkVfQ09ERShWSVJJ
RElBTl9ET01BSU4pOiBkdW1wX3ZpcmlkaWFuX2RvbWFpbigpOyBicmVhazsKICAgICAgICAgY2Fz
ZSBIVk1fU0FWRV9DT0RFKFZJUklESUFOX1ZDUFUpOiBkdW1wX3ZpcmlkaWFuX3ZjcHUoKTsgYnJl
YWs7CisgICAgICAgIGNhc2UgSFZNX1NBVkVfQ09ERShWTUNFX1ZDUFUpOiBkdW1wX3ZtY2VfdmNw
dSgpOyBicmVhazsKICAgICAgICAgY2FzZSBIVk1fU0FWRV9DT0RFKEVORCk6IGJyZWFrOwogICAg
ICAgICBkZWZhdWx0OgogICAgICAgICAgICAgcHJpbnRmKCIgKiogRG9uJ3QgdW5kZXJzdGFuZCB0
eXBlICV1OiBza2lwcGluZ1xuIiwKLS0tIGEveGVuL2FyY2gveDg2L2NwdS9tY2hlY2svbWNlLmgK
KysrIGIveGVuL2FyY2gveDg2L2NwdS9tY2hlY2svbWNlLmgKQEAgLTMsNiArMyw3IEBACiAjZGVm
aW5lIF9NQ0VfSAogCiAjaW5jbHVkZSA8eGVuL2luaXQuaD4KKyNpbmNsdWRlIDx4ZW4vc2NoZWQu
aD4KICNpbmNsdWRlIDx4ZW4vc21wLmg+CiAjaW5jbHVkZSA8YXNtL3R5cGVzLmg+CiAjaW5jbHVk
ZSA8YXNtL3RyYXBzLmg+CkBAIC01NCw4ICs1NSw4IEBAIGludCB1bm1tYXBfYnJva2VuX3BhZ2Uo
c3RydWN0IGRvbWFpbiAqZCwKIHU2NCBtY2VfY2FwX2luaXQodm9pZCk7CiBleHRlcm4gdW5zaWdu
ZWQgaW50IGZpcnN0YmFuazsKIAotaW50IGludGVsX21jZV9yZG1zcih1aW50MzJfdCBtc3IsIHVp
bnQ2NF90ICp2YWwpOwotaW50IGludGVsX21jZV93cm1zcih1aW50MzJfdCBtc3IsIHVpbnQ2NF90
IHZhbCk7CitpbnQgaW50ZWxfbWNlX3JkbXNyKGNvbnN0IHN0cnVjdCB2Y3B1ICosIHVpbnQzMl90
IG1zciwgdWludDY0X3QgKnZhbCk7CitpbnQgaW50ZWxfbWNlX3dybXNyKHN0cnVjdCB2Y3B1ICos
IHVpbnQzMl90IG1zciwgdWludDY0X3QgdmFsKTsKIAogc3RydWN0IG1jaW5mb19leHRlbmRlZCAq
aW50ZWxfZ2V0X2V4dGVuZGVkX21zcnMoCiAgICAgc3RydWN0IG1jaW5mb19nbG9iYWwgKm1pZywg
c3RydWN0IG1jX2luZm8gKm1pKTsKQEAgLTE3MSwxOCArMTcyLDIwIEBAIGludCB2bWNlX2RvbWFp
bl9pbmplY3Qoc3RydWN0IG1jaW5mb19iYW4KIAogZXh0ZXJuIGludCB2bWNlX2luaXQoc3RydWN0
IGNwdWluZm9feDg2ICpjKTsKIAotc3RhdGljIGlubGluZSBpbnQgbWNlX3ZlbmRvcl9iYW5rX21z
cih1aW50MzJfdCBtc3IpCitzdGF0aWMgaW5saW5lIGludCBtY2VfdmVuZG9yX2JhbmtfbXNyKGNv
bnN0IHN0cnVjdCB2Y3B1ICp2LCB1aW50MzJfdCBtc3IpCiB7CiAgICAgaWYgKCBib290X2NwdV9k
YXRhLng4Nl92ZW5kb3IgPT0gWDg2X1ZFTkRPUl9JTlRFTCAmJgotICAgICAgICAgbXNyID49IE1T
Ul9JQTMyX01DMF9DVEwyICYmIG1zciA8IChNU1JfSUEzMl9NQzBfQ1RMMiArIG5yX21jZV9iYW5r
cykgKQorICAgICAgICAgbXNyID49IE1TUl9JQTMyX01DMF9DVEwyICYmCisgICAgICAgICBtc3Ig
PCBNU1JfSUEzMl9NQ3hfQ1RMMih2LT5hcmNoLm1jZ19jYXAgJiBNQ0dfQ0FQX0NPVU5UKSApCiAg
ICAgICAgICAgcmV0dXJuIDE7CiAgICAgcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbmxpbmUgaW50
IG1jZV9iYW5rX21zcih1aW50MzJfdCBtc3IpCitzdGF0aWMgaW5saW5lIGludCBtY2VfYmFua19t
c3IoY29uc3Qgc3RydWN0IHZjcHUgKnYsIHVpbnQzMl90IG1zcikKIHsKLSAgICBpZiAoIChtc3Ig
Pj0gTVNSX0lBMzJfTUMwX0NUTCAmJiBtc3IgPCBNU1JfSUEzMl9NQ3hfQ1RMKG5yX21jZV9iYW5r
cykpIHx8Ci0gICAgICAgIG1jZV92ZW5kb3JfYmFua19tc3IobXNyKSApCisgICAgaWYgKCAobXNy
ID49IE1TUl9JQTMyX01DMF9DVEwgJiYKKyAgICAgICAgICBtc3IgPCBNU1JfSUEzMl9NQ3hfQ1RM
KHYtPmFyY2gubWNnX2NhcCAmIE1DR19DQVBfQ09VTlQpKSB8fAorICAgICAgICAgbWNlX3ZlbmRv
cl9iYW5rX21zcih2LCBtc3IpICkKICAgICAgICAgcmV0dXJuIDE7CiAgICAgcmV0dXJuIDA7CiB9
Ci0tLSBhL3hlbi9hcmNoL3g4Ni9jcHUvbWNoZWNrL21jZV9pbnRlbC5jCisrKyBiL3hlbi9hcmNo
L3g4Ni9jcHUvbWNoZWNrL21jZV9pbnRlbC5jCkBAIC0xNDIxLDExICsxNDIxLDEyIEBAIGVudW0g
bWNoZWNrX3R5cGUgaW50ZWxfbWNoZWNrX2luaXQoc3RydWMKIH0KIAogLyogaW50ZWwgc3BlY2lm
aWMgTUNBIE1TUiAqLwotaW50IGludGVsX21jZV93cm1zcih1aW50MzJfdCBtc3IsIHVpbnQ2NF90
IHZhbCkKK2ludCBpbnRlbF9tY2Vfd3Jtc3Ioc3RydWN0IHZjcHUgKnYsIHVpbnQzMl90IG1zciwg
dWludDY0X3QgdmFsKQogewogICAgIGludCByZXQgPSAwOwogCi0gICAgaWYgKG1zciA+PSBNU1Jf
SUEzMl9NQzBfQ1RMMiAmJiBtc3IgPCAoTVNSX0lBMzJfTUMwX0NUTDIgKyBucl9tY2VfYmFua3Mp
KQorICAgIGlmICggbXNyID49IE1TUl9JQTMyX01DMF9DVEwyICYmCisgICAgICAgICBtc3IgPCBN
U1JfSUEzMl9NQ3hfQ1RMMih2LT5hcmNoLm1jZ19jYXAgJiBNQ0dfQ0FQX0NPVU5UKSApCiAgICAg
ewogICAgICAgICBtY2VfcHJpbnRrKE1DRV9RVUlFVCwgIldlIGhhdmUgZGlzYWJsZWQgQ01DSSBj
YXBhYmlsaXR5LCAiCiAgICAgICAgICAgICAgICAgICJHdWVzdCBzaG91bGQgbm90IHdyaXRlIHRo
aXMgTVNSIVxuIik7CkBAIC0xNDM1LDExICsxNDM2LDEyIEBAIGludCBpbnRlbF9tY2Vfd3Jtc3Io
dWludDMyX3QgbXNyLCB1aW50NjQKICAgICByZXR1cm4gcmV0OwogfQogCi1pbnQgaW50ZWxfbWNl
X3JkbXNyKHVpbnQzMl90IG1zciwgdWludDY0X3QgKnZhbCkKK2ludCBpbnRlbF9tY2VfcmRtc3Io
Y29uc3Qgc3RydWN0IHZjcHUgKnYsIHVpbnQzMl90IG1zciwgdWludDY0X3QgKnZhbCkKIHsKICAg
ICBpbnQgcmV0ID0gMDsKIAotICAgIGlmIChtc3IgPj0gTVNSX0lBMzJfTUMwX0NUTDIgJiYgbXNy
IDwgKE1TUl9JQTMyX01DMF9DVEwyICsgbnJfbWNlX2JhbmtzKSkKKyAgICBpZiAoIG1zciA+PSBN
U1JfSUEzMl9NQzBfQ1RMMiAmJgorICAgICAgICAgbXNyIDwgTVNSX0lBMzJfTUN4X0NUTDIodi0+
YXJjaC5tY2dfY2FwICYgTUNHX0NBUF9DT1VOVCkgKQogICAgIHsKICAgICAgICAgbWNlX3ByaW50
ayhNQ0VfUVVJRVQsICJXZSBoYXZlIGRpc2FibGVkIENNQ0kgY2FwYWJpbGl0eSwgIgogICAgICAg
ICAgICAgICAgICAiR3Vlc3Qgc2hvdWxkIG5vdCByZWFkIHRoaXMgTVNSIVxuIik7Ci0tLSBhL3hl
bi9hcmNoL3g4Ni9jcHUvbWNoZWNrL3ZtY2UuYworKysgYi94ZW4vYXJjaC94ODYvY3B1L21jaGVj
ay92bWNlLmMKQEAgLTEwLDYgKzEwLDcgQEAKICNpbmNsdWRlIDx4ZW4vZGVsYXkuaD4KICNpbmNs
dWRlIDx4ZW4vc21wLmg+CiAjaW5jbHVkZSA8eGVuL21tLmg+CisjaW5jbHVkZSA8eGVuL2h2bS9z
YXZlLmg+CiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgogI2luY2x1ZGUgPHB1YmxpYy9zeXNj
dGwuaD4KICNpbmNsdWRlIDxhc20vc3lzdGVtLmg+CkBAIC00Miw3ICs0Myw2IEBAIGludCB2bWNl
X2luaXRfbXNyKHN0cnVjdCBkb21haW4gKmQpCiAgICAgICAgICAgIG5yX21jZV9iYW5rcyAqIHNp
emVvZigqZG9tX3ZtY2UoZCktPm1jaV9jdGwpKTsKIAogICAgIGRvbV92bWNlKGQpLT5tY2dfc3Rh
dHVzID0gMHgwOwotICAgIGRvbV92bWNlKGQpLT5tY2dfY2FwID0gZ19tY2dfY2FwOwogICAgIGRv
bV92bWNlKGQpLT5tY2dfY3RsID0gfih1aW50NjRfdCkweDA7CiAgICAgZG9tX3ZtY2UoZCktPm5y
X2luamVjdGlvbiA9IDA7CiAKQEAgLTYxLDIxICs2MSw0MSBAQCB2b2lkIHZtY2VfZGVzdHJveV9t
c3Ioc3RydWN0IGRvbWFpbiAqZCkKICAgICBkb21fdm1jZShkKSA9IE5VTEw7CiB9CiAKLXN0YXRp
YyBpbnQgYmFua19tY2VfcmRtc3Ioc3RydWN0IGRvbWFpbiAqZCwgdWludDMyX3QgbXNyLCB1aW50
NjRfdCAqdmFsKQordm9pZCB2bWNlX2luaXRfdmNwdShzdHJ1Y3QgdmNwdSAqdikKIHsKLSAgICBp
bnQgYmFuaywgcmV0ID0gMTsKLSAgICBzdHJ1Y3QgZG9tYWluX21jYV9tc3JzICp2bWNlID0gZG9t
X3ZtY2UoZCk7CisgICAgdi0+YXJjaC5tY2dfY2FwID0gZ19tY2dfY2FwOworfQorCitpbnQgdm1j
ZV9yZXN0b3JlX3ZjcHUoc3RydWN0IHZjcHUgKnYsIHVpbnQ2NF90IGNhcHMpCit7CisgICAgaWYg
KCBjYXBzICYgfmdfbWNnX2NhcCAmIH5NQ0dfQ0FQX0NPVU5UICYgfk1DR19DVExfUCApCisgICAg
eworICAgICAgICBkcHJpbnRrKFhFTkxPR19HX0VSUiwgIiVzIHJlc3RvcmU6IHVuc3VwcG9ydGVk
IE1DQSBjYXBhYmlsaXRpZXMiCisgICAgICAgICAgICAgICAgIiAlIyIgUFJJeDY0ICIgZm9yIGQl
ZDp2JXUgKHN1cHBvcnRlZDogJSNMeClcbiIsCisgICAgICAgICAgICAgICAgaXNfaHZtX3ZjcHUo
dikgPyAiSFZNIiA6ICJQViIsIGNhcHMsIHYtPmRvbWFpbi0+ZG9tYWluX2lkLAorICAgICAgICAg
ICAgICAgIHYtPnZjcHVfaWQsIGdfbWNnX2NhcCAmIH5NQ0dfQ0FQX0NPVU5UKTsKKyAgICAgICAg
cmV0dXJuIC1FUEVSTTsKKyAgICB9CisKKyAgICB2LT5hcmNoLm1jZ19jYXAgPSBjYXBzOworICAg
IHJldHVybiAwOworfQorCitzdGF0aWMgaW50IGJhbmtfbWNlX3JkbXNyKGNvbnN0IHN0cnVjdCB2
Y3B1ICp2LCB1aW50MzJfdCBtc3IsIHVpbnQ2NF90ICp2YWwpCit7CisgICAgaW50IHJldCA9IDE7
CisgICAgdW5zaWduZWQgaW50IGJhbmsgPSAobXNyIC0gTVNSX0lBMzJfTUMwX0NUTCkgLyA0Owor
ICAgIHN0cnVjdCBkb21haW5fbWNhX21zcnMgKnZtY2UgPSBkb21fdm1jZSh2LT5kb21haW4pOwog
ICAgIHN0cnVjdCBiYW5rX2VudHJ5ICplbnRyeTsKIAotICAgIGJhbmsgPSAobXNyIC0gTVNSX0lB
MzJfTUMwX0NUTCkgLyA0OwotICAgIGlmICggYmFuayA+PSBucl9tY2VfYmFua3MgKQotICAgICAg
ICByZXR1cm4gLTE7CisgICAgKnZhbCA9IDA7CiAKICAgICBzd2l0Y2ggKCBtc3IgJiAoTVNSX0lB
MzJfTUMwX0NUTCB8IDMpICkKICAgICB7CiAgICAgY2FzZSBNU1JfSUEzMl9NQzBfQ1RMOgotICAg
ICAgICAqdmFsID0gdm1jZS0+bWNpX2N0bFtiYW5rXSAmCi0gICAgICAgICAgICAoaF9tY2lfY3Ry
bCA/IGhfbWNpX2N0cmxbYmFua10gOiB+MFVMKTsKKyAgICAgICAgaWYgKCBiYW5rIDwgbnJfbWNl
X2JhbmtzICkKKyAgICAgICAgICAgICp2YWwgPSB2bWNlLT5tY2lfY3RsW2JhbmtdICYKKyAgICAg
ICAgICAgICAgICAgICAoaF9tY2lfY3RybCA/IGhfbWNpX2N0cmxbYmFua10gOiB+MFVMKTsKICAg
ICAgICAgbWNlX3ByaW50ayhNQ0VfVkVSQk9TRSwgIk1DRTogcmRtc3IgTUMldV9DVEwgMHglIlBS
SXg2NCJcbiIsCiAgICAgICAgICAgICAgICAgICAgYmFuaywgKnZhbCk7CiAgICAgICAgIGJyZWFr
OwpAQCAtMTI2LDcgKzE0Niw3IEBAIHN0YXRpYyBpbnQgYmFua19tY2VfcmRtc3Ioc3RydWN0IGRv
bWFpbiAKICAgICAgICAgc3dpdGNoICggYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yICkKICAgICAg
ICAgewogICAgICAgICBjYXNlIFg4Nl9WRU5ET1JfSU5URUw6Ci0gICAgICAgICAgICByZXQgPSBp
bnRlbF9tY2VfcmRtc3IobXNyLCB2YWwpOworICAgICAgICAgICAgcmV0ID0gaW50ZWxfbWNlX3Jk
bXNyKHYsIG1zciwgdmFsKTsKICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICBkZWZhdWx0Ogog
ICAgICAgICAgICAgcmV0ID0gMDsKQEAgLTE0NSwxMyArMTY1LDEzIEBAIHN0YXRpYyBpbnQgYmFu
a19tY2VfcmRtc3Ioc3RydWN0IGRvbWFpbiAKICAqLwogaW50IHZtY2VfcmRtc3IodWludDMyX3Qg
bXNyLCB1aW50NjRfdCAqdmFsKQogewotICAgIHN0cnVjdCBkb21haW4gKmQgPSBjdXJyZW50LT5k
b21haW47Ci0gICAgc3RydWN0IGRvbWFpbl9tY2FfbXNycyAqdm1jZSA9IGRvbV92bWNlKGQpOwor
ICAgIGNvbnN0IHN0cnVjdCB2Y3B1ICpjdXIgPSBjdXJyZW50OworICAgIHN0cnVjdCBkb21haW5f
bWNhX21zcnMgKnZtY2UgPSBkb21fdm1jZShjdXItPmRvbWFpbik7CiAgICAgaW50IHJldCA9IDE7
CiAKICAgICAqdmFsID0gMDsKIAotICAgIHNwaW5fbG9jaygmZG9tX3ZtY2UoZCktPmxvY2spOwor
ICAgIHNwaW5fbG9jaygmdm1jZS0+bG9jayk7CiAKICAgICBzd2l0Y2ggKCBtc3IgKQogICAgIHsK
QEAgLTE2MiwzOSArMTgyLDM4IEBAIGludCB2bWNlX3JkbXNyKHVpbnQzMl90IG1zciwgdWludDY0
X3QgKnYKICAgICAgICAgICAgICAgICAgICAgICAgIk1DRTogcmRtc3IgTUNHX1NUQVRVUyAweCUi
UFJJeDY0IlxuIiwgKnZhbCk7CiAgICAgICAgIGJyZWFrOwogICAgIGNhc2UgTVNSX0lBMzJfTUNH
X0NBUDoKLSAgICAgICAgKnZhbCA9IHZtY2UtPm1jZ19jYXA7CisgICAgICAgICp2YWwgPSBjdXIt
PmFyY2gubWNnX2NhcDsKICAgICAgICAgbWNlX3ByaW50ayhNQ0VfVkVSQk9TRSwgIk1DRTogcmRt
c3IgTUNHX0NBUCAweCUiUFJJeDY0IlxuIiwKICAgICAgICAgICAgICAgICAgICAqdmFsKTsKICAg
ICAgICAgYnJlYWs7CiAgICAgY2FzZSBNU1JfSUEzMl9NQ0dfQ1RMOgogICAgICAgICAvKiBBbHdh
eXMgMCBpZiBubyBDVEwgc3VwcG9ydCAqLwotICAgICAgICAqdmFsID0gdm1jZS0+bWNnX2N0bCAm
IGhfbWNnX2N0bDsKKyAgICAgICAgaWYgKCBjdXItPmFyY2gubWNnX2NhcCAmIE1DR19DVExfUCAp
CisgICAgICAgICAgICAqdmFsID0gdm1jZS0+bWNnX2N0bCAmIGhfbWNnX2N0bDsKICAgICAgICAg
bWNlX3ByaW50ayhNQ0VfVkVSQk9TRSwgIk1DRTogcmRtc3IgTUNHX0NUTCAweCUiUFJJeDY0Ilxu
IiwKICAgICAgICAgICAgICAgICAgICAqdmFsKTsKICAgICAgICAgYnJlYWs7CiAgICAgZGVmYXVs
dDoKLSAgICAgICAgcmV0ID0gbWNlX2JhbmtfbXNyKG1zcikgPyBiYW5rX21jZV9yZG1zcihkLCBt
c3IsIHZhbCkgOiAwOworICAgICAgICByZXQgPSBtY2VfYmFua19tc3IoY3VyLCBtc3IpID8gYmFu
a19tY2VfcmRtc3IoY3VyLCBtc3IsIHZhbCkgOiAwOwogICAgICAgICBicmVhazsKICAgICB9CiAK
LSAgICBzcGluX3VubG9jaygmZG9tX3ZtY2UoZCktPmxvY2spOworICAgIHNwaW5fdW5sb2NrKCZ2
bWNlLT5sb2NrKTsKICAgICByZXR1cm4gcmV0OwogfQogCi1zdGF0aWMgaW50IGJhbmtfbWNlX3dy
bXNyKHN0cnVjdCBkb21haW4gKmQsIHUzMiBtc3IsIHU2NCB2YWwpCitzdGF0aWMgaW50IGJhbmtf
bWNlX3dybXNyKHN0cnVjdCB2Y3B1ICp2LCB1MzIgbXNyLCB1NjQgdmFsKQogewotICAgIGludCBi
YW5rLCByZXQgPSAxOwotICAgIHN0cnVjdCBkb21haW5fbWNhX21zcnMgKnZtY2UgPSBkb21fdm1j
ZShkKTsKKyAgICBpbnQgcmV0ID0gMTsKKyAgICB1bnNpZ25lZCBpbnQgYmFuayA9IChtc3IgLSBN
U1JfSUEzMl9NQzBfQ1RMKSAvIDQ7CisgICAgc3RydWN0IGRvbWFpbl9tY2FfbXNycyAqdm1jZSA9
IGRvbV92bWNlKHYtPmRvbWFpbik7CiAgICAgc3RydWN0IGJhbmtfZW50cnkgKmVudHJ5ID0gTlVM
TDsKIAotICAgIGJhbmsgPSAobXNyIC0gTVNSX0lBMzJfTUMwX0NUTCkgLyA0OwotICAgIGlmICgg
YmFuayA+PSBucl9tY2VfYmFua3MgKQotICAgICAgICByZXR1cm4gLUVJTlZBTDsKLQogICAgIHN3
aXRjaCAoIG1zciAmIChNU1JfSUEzMl9NQzBfQ1RMIHwgMykgKQogICAgIHsKICAgICBjYXNlIE1T
Ul9JQTMyX01DMF9DVEw6Ci0gICAgICAgIHZtY2UtPm1jaV9jdGxbYmFua10gPSB2YWw7CisgICAg
ICAgIGlmICggYmFuayA8IG5yX21jZV9iYW5rcyApCisgICAgICAgICAgICB2bWNlLT5tY2lfY3Rs
W2JhbmtdID0gdmFsOwogICAgICAgICBicmVhazsKICAgICBjYXNlIE1TUl9JQTMyX01DMF9TVEFU
VVM6CiAgICAgICAgIC8qIEdpdmUgdGhlIGZpcnN0IGVudHJ5IG9mIHRoZSBsaXN0LCBpdCBjb3Jy
ZXNwb25kcyB0byBjdXJyZW50CkBAIC0yMDIsOSArMjIxLDkgQEAgc3RhdGljIGludCBiYW5rX21j
ZV93cm1zcihzdHJ1Y3QgZG9tYWluIAogICAgICAgICAgKiB0aGUgZ3Vlc3QsIHRoaXMgbm9kZSB3
aWxsIGJlIGRlbGV0ZWQuCiAgICAgICAgICAqIE9ubHkgZXJyb3IgYmFuayBpcyB3cml0dGVuLiBO
b24tZXJyb3IgYmFua3Mgc2ltcGx5IHJldHVybi4KICAgICAgICAgICovCi0gICAgICAgIGlmICgg
IWxpc3RfZW1wdHkoJmRvbV92bWNlKGQpLT5pbXBhY3RfaGVhZGVyKSApCisgICAgICAgIGlmICgg
IWxpc3RfZW1wdHkoJnZtY2UtPmltcGFjdF9oZWFkZXIpICkKICAgICAgICAgewotICAgICAgICAg
ICAgZW50cnkgPSBsaXN0X2VudHJ5KGRvbV92bWNlKGQpLT5pbXBhY3RfaGVhZGVyLm5leHQsCisg
ICAgICAgICAgICBlbnRyeSA9IGxpc3RfZW50cnkodm1jZS0+aW1wYWN0X2hlYWRlci5uZXh0LAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBiYW5rX2VudHJ5LCBsaXN0KTsK
ICAgICAgICAgICAgIGlmICggZW50cnktPmJhbmsgPT0gYmFuayApCiAgICAgICAgICAgICAgICAg
ZW50cnktPm1jaV9zdGF0dXMgPSB2YWw7CkBAIC0yMjgsNyArMjQ3LDcgQEAgc3RhdGljIGludCBi
YW5rX21jZV93cm1zcihzdHJ1Y3QgZG9tYWluIAogICAgICAgICBzd2l0Y2ggKCBib290X2NwdV9k
YXRhLng4Nl92ZW5kb3IgKQogICAgICAgICB7CiAgICAgICAgIGNhc2UgWDg2X1ZFTkRPUl9JTlRF
TDoKLSAgICAgICAgICAgIHJldCA9IGludGVsX21jZV93cm1zcihtc3IsIHZhbCk7CisgICAgICAg
ICAgICByZXQgPSBpbnRlbF9tY2Vfd3Jtc3IodiwgbXNyLCB2YWwpOwogICAgICAgICAgICAgYnJl
YWs7CiAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgICByZXQgPSAwOwpAQCAtMjQ3LDkgKzI2
Niw5IEBAIHN0YXRpYyBpbnQgYmFua19tY2Vfd3Jtc3Ioc3RydWN0IGRvbWFpbiAKICAqLwogaW50
IHZtY2Vfd3Jtc3IodTMyIG1zciwgdTY0IHZhbCkKIHsKLSAgICBzdHJ1Y3QgZG9tYWluICpkID0g
Y3VycmVudC0+ZG9tYWluOworICAgIHN0cnVjdCB2Y3B1ICpjdXIgPSBjdXJyZW50OwogICAgIHN0
cnVjdCBiYW5rX2VudHJ5ICplbnRyeSA9IE5VTEw7Ci0gICAgc3RydWN0IGRvbWFpbl9tY2FfbXNy
cyAqdm1jZSA9IGRvbV92bWNlKGQpOworICAgIHN0cnVjdCBkb21haW5fbWNhX21zcnMgKnZtY2Ug
PSBkb21fdm1jZShjdXItPmRvbWFpbik7CiAgICAgaW50IHJldCA9IDE7CiAKICAgICBpZiAoICFn
X21jZ19jYXAgKQpAQCAtMjY2LDcgKzI4NSw3IEBAIGludCB2bWNlX3dybXNyKHUzMiBtc3IsIHU2
NCB2YWwpCiAgICAgICAgIHZtY2UtPm1jZ19zdGF0dXMgPSB2YWw7CiAgICAgICAgIG1jZV9wcmlu
dGsoTUNFX1ZFUkJPU0UsICJNQ0U6IHdybXNyIE1DR19TVEFUVVMgJSJQUkl4NjQiXG4iLCB2YWwp
OwogICAgICAgICAvKiBGb3IgSFZNIGd1ZXN0LCB0aGlzIGlzIHRoZSBwb2ludCBmb3IgZGVsZXRp
bmcgdk1DRSBpbmplY3Rpb24gbm9kZSAqLwotICAgICAgICBpZiAoIGQtPmlzX2h2bSAmJiAodm1j
ZS0+bnJfaW5qZWN0aW9uID4gMCkgKQorICAgICAgICBpZiAoIGlzX2h2bV92Y3B1KGN1cikgJiYg
KHZtY2UtPm5yX2luamVjdGlvbiA+IDApICkKICAgICAgICAgewogICAgICAgICAgICAgdm1jZS0+
bnJfaW5qZWN0aW9uLS07IC8qIFNob3VsZCBiZSAwICovCiAgICAgICAgICAgICBpZiAoICFsaXN0
X2VtcHR5KCZ2bWNlLT5pbXBhY3RfaGVhZGVyKSApCkBAIC0yOTMsNyArMzEyLDcgQEAgaW50IHZt
Y2Vfd3Jtc3IodTMyIG1zciwgdTY0IHZhbCkKICAgICAgICAgcmV0ID0gLTE7CiAgICAgICAgIGJy
ZWFrOwogICAgIGRlZmF1bHQ6Ci0gICAgICAgIHJldCA9IG1jZV9iYW5rX21zcihtc3IpID8gYmFu
a19tY2Vfd3Jtc3IoZCwgbXNyLCB2YWwpIDogMDsKKyAgICAgICAgcmV0ID0gbWNlX2JhbmtfbXNy
KGN1ciwgbXNyKSA/IGJhbmtfbWNlX3dybXNyKGN1ciwgbXNyLCB2YWwpIDogMDsKICAgICAgICAg
YnJlYWs7CiAgICAgfQogCkBAIC0zMDEsNiArMzIwLDQ2IEBAIGludCB2bWNlX3dybXNyKHUzMiBt
c3IsIHU2NCB2YWwpCiAgICAgcmV0dXJuIHJldDsKIH0KIAorc3RhdGljIGludCB2bWNlX3NhdmVf
dmNwdV9jdHh0KHN0cnVjdCBkb21haW4gKmQsIGh2bV9kb21haW5fY29udGV4dF90ICpoKQorewor
ICAgIHN0cnVjdCB2Y3B1ICp2OworICAgIGludCBlcnIgPSAwOworCisgICAgZm9yX2VhY2hfdmNw
dSggZCwgdiApIHsKKyAgICAgICAgc3RydWN0IGh2bV92bWNlX3ZjcHUgY3R4dCA9IHsKKyAgICAg
ICAgICAgIC5jYXBzID0gdi0+YXJjaC5tY2dfY2FwCisgICAgICAgIH07CisKKyAgICAgICAgZXJy
ID0gaHZtX3NhdmVfZW50cnkoVk1DRV9WQ1BVLCB2LT52Y3B1X2lkLCBoLCAmY3R4dCk7CisgICAg
ICAgIGlmICggZXJyICkKKyAgICAgICAgICAgIGJyZWFrOworICAgIH0KKworICAgIHJldHVybiBl
cnI7Cit9CisKK3N0YXRpYyBpbnQgdm1jZV9sb2FkX3ZjcHVfY3R4dChzdHJ1Y3QgZG9tYWluICpk
LCBodm1fZG9tYWluX2NvbnRleHRfdCAqaCkKK3sKKyAgICB1bnNpZ25lZCBpbnQgdmNwdWlkID0g
aHZtX2xvYWRfaW5zdGFuY2UoaCk7CisgICAgc3RydWN0IHZjcHUgKnY7CisgICAgc3RydWN0IGh2
bV92bWNlX3ZjcHUgY3R4dDsKKyAgICBpbnQgZXJyOworCisgICAgaWYgKCB2Y3B1aWQgPj0gZC0+
bWF4X3ZjcHVzIHx8ICh2ID0gZC0+dmNwdVt2Y3B1aWRdKSA9PSBOVUxMICkKKyAgICB7CisgICAg
ICAgIGRwcmludGsoWEVOTE9HX0dfRVJSLCAiSFZNIHJlc3RvcmU6IGRvbSVkIGhhcyBubyB2Y3B1
JXVcbiIsCisgICAgICAgICAgICAgICAgZC0+ZG9tYWluX2lkLCB2Y3B1aWQpOworICAgICAgICBl
cnIgPSAtRUlOVkFMOworICAgIH0KKyAgICBlbHNlCisgICAgICAgIGVyciA9IGh2bV9sb2FkX2Vu
dHJ5KFZNQ0VfVkNQVSwgaCwgJmN0eHQpOworCisgICAgcmV0dXJuIGVyciA/OiB2bWNlX3Jlc3Rv
cmVfdmNwdSh2LCBjdHh0LmNhcHMpOworfQorCitIVk1fUkVHSVNURVJfU0FWRV9SRVNUT1JFKFZN
Q0VfVkNQVSwgdm1jZV9zYXZlX3ZjcHVfY3R4dCwKKyAgICAgICAgICAgICAgICAgICAgICAgICAg
dm1jZV9sb2FkX3ZjcHVfY3R4dCwgMSwgSFZNU1JfUEVSX1ZDUFUpOworCiBpbnQgaW5qZWN0X3Zt
Y2Uoc3RydWN0IGRvbWFpbiAqZCkKIHsKICAgICBpbnQgY3B1ID0gc21wX3Byb2Nlc3Nvcl9pZCgp
OwotLS0gYS94ZW4vYXJjaC94ODYvZG9tYWluLmMKKysrIGIveGVuL2FyY2gveDg2L2RvbWFpbi5j
CkBAIC00MjIsNiArNDIyLDggQEAgaW50IHZjcHVfaW5pdGlhbGlzZShzdHJ1Y3QgdmNwdSAqdikK
ICAgICBpZiAoIChyYyA9IHZjcHVfaW5pdF9mcHUodikpICE9IDAgKQogICAgICAgICByZXR1cm4g
cmM7CiAKKyAgICB2bWNlX2luaXRfdmNwdSh2KTsKKwogICAgIGlmICggaXNfaHZtX2RvbWFpbihk
KSApCiAgICAgewogICAgICAgICByYyA9IGh2bV92Y3B1X2luaXRpYWxpc2Uodik7Ci0tLSBhL3hl
bi9hcmNoL3g4Ni9kb21jdGwuYworKysgYi94ZW4vYXJjaC94ODYvZG9tY3RsLmMKQEAgLTEwMjcs
MTEgKzEwMjcsMTIgQEAgbG9uZyBhcmNoX2RvX2RvbWN0bCgKICAgICAgICAgICAgICAgICBldmMt
PnN5c2NhbGwzMl9jYWxsYmFja19laXAgICAgPSAwOwogICAgICAgICAgICAgICAgIGV2Yy0+c3lz
Y2FsbDMyX2Rpc2FibGVzX2V2ZW50cyA9IDA7CiAgICAgICAgICAgICB9CisgICAgICAgICAgICBl
dmMtPm1jZ19jYXAgPSB2LT5hcmNoLm1jZ19jYXA7CiAgICAgICAgIH0KICAgICAgICAgZWxzZQog
ICAgICAgICB7CiAgICAgICAgICAgICByZXQgPSAtRUlOVkFMOwotICAgICAgICAgICAgaWYgKCBl
dmMtPnNpemUgIT0gc2l6ZW9mKCpldmMpICkKKyAgICAgICAgICAgIGlmICggZXZjLT5zaXplIDwg
b2Zmc2V0b2YodHlwZW9mKCpldmMpLCBtY2dfY2FwKSApCiAgICAgICAgICAgICAgICAgZ290byBl
eHRfdmNwdWNvbnRleHRfb3V0OwogI2lmZGVmIF9feDg2XzY0X18KICAgICAgICAgICAgIGlmICgg
IWlzX2h2bV9kb21haW4oZCkgKQpAQCAtMTA1OSw2ICsxMDYwLDEwIEBAIGxvbmcgYXJjaF9kb19k
b21jdGwoCiAgICAgICAgICAgICAgICAgIChldmMtPnN5c2NhbGwzMl9jYWxsYmFja19jcyAmIH4z
KSB8fAogICAgICAgICAgICAgICAgICBldmMtPnN5c2NhbGwzMl9jYWxsYmFja19laXAgKQogICAg
ICAgICAgICAgICAgIGdvdG8gZXh0X3ZjcHVjb250ZXh0X291dDsKKworICAgICAgICAgICAgaWYg
KCBldmMtPnNpemUgPj0gb2Zmc2V0b2YodHlwZW9mKCpldmMpLCBtY2dfY2FwKSArCisgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzaXplb2YoZXZjLT5tY2dfY2FwKSApCisgICAgICAgICAg
ICAgICAgcmV0ID0gdm1jZV9yZXN0b3JlX3ZjcHUodiwgZXZjLT5tY2dfY2FwKTsKICAgICAgICAg
fQogCiAgICAgICAgIHJldCA9IDA7Ci0tLSBhL3hlbi9pbmNsdWRlL2FzbS14ODYvZG9tYWluLmgK
KysrIGIveGVuL2luY2x1ZGUvYXNtLXg4Ni9kb21haW4uaApAQCAtNDg4LDYgKzQ4OCw4IEBAIHN0
cnVjdCBhcmNoX3ZjcHUKICAgICAvKiBUaGlzIHZhcmlhYmxlIGRldGVybWluZXMgd2hldGhlciBu
b25sYXp5IGV4dGVuZGVkIHN0YXRlIGhhcyBiZWVuIHVzZWQsCiAgICAgICogYW5kIHRodXMgc2hv
dWxkIGJlIHNhdmVkL3Jlc3RvcmVkLiAqLwogICAgIGJvb2xfdCBub25sYXp5X3hzdGF0ZV91c2Vk
OworCisgICAgdWludDY0X3QgbWNnX2NhcDsKICAgICAKICAgICBzdHJ1Y3QgcGFnaW5nX3ZjcHUg
cGFnaW5nOwogCi0tLSBhL3hlbi9pbmNsdWRlL2FzbS14ODYvbWNlLmgKKysrIGIveGVuL2luY2x1
ZGUvYXNtLXg4Ni9tY2UuaApAQCAtMTYsNyArMTYsNiBAQCBzdHJ1Y3QgYmFua19lbnRyeSB7CiBz
dHJ1Y3QgZG9tYWluX21jYV9tc3JzCiB7CiAgICAgLyogR3Vlc3Qgc2hvdWxkIG5vdCBjaGFuZ2Ug
YmVsb3cgdmFsdWVzIGFmdGVyIERPTSBib290IHVwICovCi0gICAgdWludDY0X3QgbWNnX2NhcDsK
ICAgICB1aW50NjRfdCBtY2dfY3RsOwogICAgIHVpbnQ2NF90IG1jZ19zdGF0dXM7CiAgICAgdWlu
dDY0X3QgKm1jaV9jdGw7CkBAIC0yOCw2ICsyNyw4IEBAIHN0cnVjdCBkb21haW5fbWNhX21zcnMK
IC8qIEd1ZXN0IHZNQ0UgTVNScyB2aXJ0dWFsaXphdGlvbiAqLwogZXh0ZXJuIGludCB2bWNlX2lu
aXRfbXNyKHN0cnVjdCBkb21haW4gKmQpOwogZXh0ZXJuIHZvaWQgdm1jZV9kZXN0cm95X21zcihz
dHJ1Y3QgZG9tYWluICpkKTsKK2V4dGVybiB2b2lkIHZtY2VfaW5pdF92Y3B1KHN0cnVjdCB2Y3B1
ICopOworZXh0ZXJuIGludCB2bWNlX3Jlc3RvcmVfdmNwdShzdHJ1Y3QgdmNwdSAqLCB1aW50NjRf
dCBjYXBzKTsKIGV4dGVybiBpbnQgdm1jZV93cm1zcih1aW50MzJfdCBtc3IsIHVpbnQ2NF90IHZh
bCk7CiBleHRlcm4gaW50IHZtY2VfcmRtc3IodWludDMyX3QgbXNyLCB1aW50NjRfdCAqdmFsKTsK
IAotLS0gYS94ZW4vaW5jbHVkZS9wdWJsaWMvYXJjaC14ODYvaHZtL3NhdmUuaAorKysgYi94ZW4v
aW5jbHVkZS9wdWJsaWMvYXJjaC14ODYvaHZtL3NhdmUuaApAQCAtNTg1LDkgKzU4NSwxNSBAQCBz
dHJ1Y3QgaHZtX3ZpcmlkaWFuX3ZjcHVfY29udGV4dCB7CiAKIERFQ0xBUkVfSFZNX1NBVkVfVFlQ
RShWSVJJRElBTl9WQ1BVLCAxNywgc3RydWN0IGh2bV92aXJpZGlhbl92Y3B1X2NvbnRleHQpOwog
CitzdHJ1Y3QgaHZtX3ZtY2VfdmNwdSB7CisgICAgdWludDY0X3QgY2FwczsKK307CisKK0RFQ0xB
UkVfSFZNX1NBVkVfVFlQRShWTUNFX1ZDUFUsIDE4LCBzdHJ1Y3QgaHZtX3ZtY2VfdmNwdSk7CisK
IC8qIAogICogTGFyZ2VzdCB0eXBlLWNvZGUgaW4gdXNlCiAgKi8KLSNkZWZpbmUgSFZNX1NBVkVf
Q09ERV9NQVggMTcKKyNkZWZpbmUgSFZNX1NBVkVfQ09ERV9NQVggMTgKIAogI2VuZGlmIC8qIF9f
WEVOX1BVQkxJQ19IVk1fU0FWRV9YODZfSF9fICovCi0tLSBhL3hlbi9pbmNsdWRlL3B1YmxpYy9k
b21jdGwuaAorKysgYi94ZW4vaW5jbHVkZS9wdWJsaWMvZG9tY3RsLmgKQEAgLTU1OSw3ICs1NTks
NyBAQCBzdHJ1Y3QgeGVuX2RvbWN0bF9leHRfdmNwdWNvbnRleHQgewogICAgIHVpbnQzMl90ICAg
ICAgICAgdmNwdTsKICAgICAvKgogICAgICAqIFNFVDogU2l6ZSBvZiBzdHJ1Y3QgKElOKQotICAg
ICAqIEdFVDogU2l6ZSBvZiBzdHJ1Y3QgKE9VVCkKKyAgICAgKiBHRVQ6IFNpemUgb2Ygc3RydWN0
IChPVVQsIHVwIHRvIDEyOCBieXRlcykKICAgICAgKi8KICAgICB1aW50MzJfdCAgICAgICAgIHNp
emU7CiAjaWYgZGVmaW5lZChfX2kzODZfXykgfHwgZGVmaW5lZChfX3g4Nl82NF9fKQpAQCAtNTcx
LDYgKzU3MSw3IEBAIHN0cnVjdCB4ZW5fZG9tY3RsX2V4dF92Y3B1Y29udGV4dCB7CiAgICAgdWlu
dDE2X3QgICAgICAgICBzeXNlbnRlcl9jYWxsYmFja19jczsKICAgICB1aW50OF90ICAgICAgICAg
IHN5c2NhbGwzMl9kaXNhYmxlc19ldmVudHM7CiAgICAgdWludDhfdCAgICAgICAgICBzeXNlbnRl
cl9kaXNhYmxlc19ldmVudHM7CisgICAgdWludDY0X2FsaWduZWRfdCBtY2dfY2FwOwogI2VuZGlm
CiB9OwogdHlwZWRlZiBzdHJ1Y3QgeGVuX2RvbWN0bF9leHRfdmNwdWNvbnRleHQgeGVuX2RvbWN0
bF9leHRfdmNwdWNvbnRleHRfdDsK

--_003_4F3B9E7E0200007800073218nat28tlfnovellcom_
Content-Type: text/plain; name="ATT00001.txt"
Content-Description: ATT00001.txt
Content-Disposition: attachment; filename="ATT00001.txt"; size=142;
	creation-date="Wed, 15 Feb 2012 11:04:26 GMT";
	modification-date="Wed, 15 Feb 2012 11:04:26 GMT"
Content-ID: <B8D27E4B2EB93741A96203690282D776@intel.com>
Content-Transfer-Encoding: base64

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NClhlbi1kZXZl
bCBtYWlsaW5nIGxpc3QNClhlbi1kZXZlbEBsaXN0cy54ZW5zb3VyY2UuY29tDQpodHRwOi8vbGlz
dHMueGVuc291cmNlLmNvbS94ZW4tZGV2ZWwNCg==

--_003_4F3B9E7E0200007800073218nat28tlfnovellcom_--

--_002_DE8DF0795D48FD4CA783C40EC8292335263B9DSHSMSX101ccrcorpi_--

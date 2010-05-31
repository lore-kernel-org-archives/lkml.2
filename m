Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0EaIK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:10:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33629 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0EaIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=iMk7NFE0i7e4eKssY+8qpM851dfDMgUFyyAOY6AaM9pVzE+gX2vtGBSHXpq4c6fl2a
         XQFsw4y+2ZphgCjPaVWgyElISWv4l7NwpR+BfIEYoQqwI5H0GDiw/Nhk4IBfDOeTST1A
         CApJymwMpzw1x1hgFQ1inUW5cI+OQjRuHouxE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimj_kruEyL3Ac7xJZt0tunTua6JDBcuAU7XbWoP@mail.gmail.com>
References: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
	<AANLkTimj_kruEyL3Ac7xJZt0tunTua6JDBcuAU7XbWoP@mail.gmail.com>
Date: Mon, 31 May 2010 10:10:51 +0200
Message-ID: <AANLkTinVrUPdaRtLIU4ZfNprJY5SVRmFDIjvOmeAzqOC@mail.gmail.com>
Subject: [FIXED] 2.6.35-rc1: Call trace: BUG: using smp_processor_id() in 
	preemptible [00000000] code: cpufreq-set/2344 (cpufreq-releated?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       markgross <mgross@linux.intel.com>, dmonakhov@openvz.org
Content-Type: multipart/mixed; boundary=0016367f9dd423a5500487df65e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016367f9dd423a5500487df65e5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[ Removed CC to "Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>"
(email-adsress seems not to exist) ]

Indeed, the patch fixes the cpufreq issue here - Thanks.

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

P.S.:
I have attached the patch from cpufreq ML, so it is available from
<patchwork.kernel.org>.

On Mon, May 31, 2010 at 8:43 AM, Sedat Dilek <sedat.dilek@googlemail.com> w=
rote:
> Damn!
> Sorry, I have found the following fix at cpufreq ML from Dmitry Monakhov =
[1].
>
> I will try it and report.
>
> - Sedat -
>
> [1] "[PATCH] cpufreq: call nr_iowait_cpu with disabled preemption"
> http://www.spinics.net/lists/cpufreq/msg01631.html
>
> On Mon, May 31, 2010 at 8:27 AM, Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>> Hi,
>>
>> with 2.6.35-rc1 I get a cpufreq-related Call trace on startup on a
>> 32-bit Debian/sid system.
>>
>> Below I added (see investigations at the end):
>>
>> 1. the version of cpufrequtils I am using
>> 2. an output of cpufreq-related loaded kernel-modules
>> 3. an output of cpufreq-related setting in kernel-config
>>
>> Furthermore, I have attched the full dmesg output and kernel-config file=
.
>>
>> Here is the Call trace:
>>
>> [ =C2=A0 31.647049] BUG: using smp_processor_id() in preemptible [000000=
00]
>> code: cpufreq-set/2344
>> [ =C2=A0 31.647299] caller is nr_iowait_cpu+0xb/0x1a
>> [ =C2=A0 31.647303] Pid: 2344, comm: cpufreq-set Not tainted
>> 2.6.35-rc1-iniza-686-kms #1
>> [ =C2=A0 31.647306] Call Trace:
>> [ =C2=A0 31.647314] =C2=A0[<c111fdd9>] ? debug_smp_processor_id+0xa5/0xb=
8
>> [ =C2=A0 31.647319] =C2=A0[<c1022f93>] ? nr_iowait_cpu+0xb/0x1a
>> [ =C2=A0 31.647325] =C2=A0[<c104a93c>] ? update_ts_time_stats+0x36/0x92
>> [ =C2=A0 31.647329] =C2=A0[<c1045fcb>] ? ktime_get+0x5b/0xd9
>> [ =C2=A0 31.647333] =C2=A0[<c104aae9>] ? get_cpu_idle_time_us+0x36/0x62
>> [ =C2=A0 31.647340] =C2=A0[<f94e433d>] ? get_cpu_idle_time+0x12/0x127 [c=
pufreq_ondemand]
>> [ =C2=A0 31.647345] =C2=A0[<c10dea11>] ? sysfs_add_file_mode+0x48/0x66
>> [ =C2=A0 31.647350] =C2=A0[<c10e0827>] ? internal_create_group+0xcf/0x13=
4
>> [ =C2=A0 31.647355] =C2=A0[<f94e4a3b>] ? cpufreq_governor_dbs+0xaa/0x2a3
>> [cpufreq_ondemand]
>> [ =C2=A0 31.647361] =C2=A0[<c119d94a>] ? __cpufreq_governor+0x2c/0x63
>> [ =C2=A0 31.647365] =C2=A0[<c119e80a>] ? __cpufreq_set_policy+0xea/0x11d
>> [ =C2=A0 31.647370] =C2=A0[<c119ea74>] ? store_scaling_governor+0x58/0x7=
c
>> [ =C2=A0 31.647375] =C2=A0[<c119ee09>] ? handle_update+0x0/0x8
>> [ =C2=A0 31.647381] =C2=A0[<c1225d70>] ? _raw_spin_unlock_irqrestore+0x2=
2/0x2c
>> [ =C2=A0 31.647385] =C2=A0[<c119ea1c>] ? store_scaling_governor+0x0/0x7c
>> [ =C2=A0 31.647389] =C2=A0[<c119e708>] ? store+0x3c/0x54
>> [ =C2=A0 31.647393] =C2=A0[<c10de76d>] ? sysfs_write_file+0xb8/0xe5
>> [ =C2=A0 31.647397] =C2=A0[<c10de6b5>] ? sysfs_write_file+0x0/0xe5
>> [ =C2=A0 31.647403] =C2=A0[<c109f7c6>] ? vfs_write+0x7f/0xda
>> [ =C2=A0 31.647408] =C2=A0[<c101dad8>] ? do_page_fault+0x1fb/0x25f
>> [ =C2=A0 31.647412] =C2=A0[<c109f8b4>] ? sys_write+0x3c/0x60
>> [ =C2=A0 31.647417] =C2=A0[<c1002e18>] ? sysenter_do_call+0x12/0x28
>>
>> Hope this helps fixing the problem.
>>
>> Kind Regards,
>> - Sedat -
>>
>> P.S.:
>> Recently I watched a video with a speeh of Greg K-H [1] and extracted
>> the maintainers/contributors via:
>>
>> $ ./scripts/get_maintainer.pl -f drivers/cpuidle/governors/menu.c <---
>> nr_iowait_cpu()
>> $ ./scripts/get_maintainer.pl -f drivers/cpufreq/cpufreq_ondemand.c
>> <--- [cpufreq_ondemand]
>>
>> [1] Write and Submit your first Linux kernel Patch:
>> http://fosdem.org/2010/schedule/events/linuxkernelpatch
>>
>> ------ INVESTIGATIONS -----
>>
>> $ env COLUMNS=3D120 dpkg -l | grep -i cpufreq
>> ii =C2=A0cpufrequtils =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 007-1 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0utilit=
ies to
>> deal with the cpufreq Linux kernel feature
>> ii =C2=A0libcpufreq0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0007=
-1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sha=
red library
>> to deal with the cpufreq Linux kernel feature
>>
>> $ sudo lsmod | grep freq | sort
>> acpi_cpufreq =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04343 =C2=A01
>> cpufreq_conservative =C2=A0 =C2=A0 6260 =C2=A00
>> cpufreq_ondemand =C2=A0 =C2=A0 =C2=A0 =C2=A05810 =C2=A02
>> cpufreq_performance =C2=A0 =C2=A0 =C2=A0590 =C2=A00
>> cpufreq_powersave =C2=A0 =C2=A0 =C2=A0 =C2=A0582 =C2=A00
>> cpufreq_stats =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1969 =C2=A00
>> freq_table =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01647 =C2=A03 =
acpi_cpufreq,cpufreq_ondemand,cpufreq_stats
>> mperf =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0899 =C2=A01 acpi_cpufreq
>> processor =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A022099 =C2=A03 =
acpi_cpufreq
>>
>> $ grep -i freq /boot/config-2.6.35-rc1-iniza-686-kms | grep -i cpu
>> # CPU Frequency scaling
>> CONFIG_CPU_FREQ=3Dy
>> CONFIG_CPU_FREQ_TABLE=3Dm
>> # CONFIG_CPU_FREQ_DEBUG is not set
>> CONFIG_CPU_FREQ_STAT=3Dm
>> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
>> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=3Dy
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
>> CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dm
>> CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
>> CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
>> CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
>> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm
>> # CPUFreq processor drivers
>> # CONFIG_X86_PCC_CPUFREQ is not set
>> CONFIG_X86_ACPI_CPUFREQ=3Dm
>> CONFIG_X86_CPUFREQ_NFORCE2=3Dm
>>
>

--0016367f9dd423a5500487df65e5
Content-Type: text/x-diff; charset=US-ASCII; 
	name="cpufreq-call-nr_iowait_cpu-with-disabled-preemption.patch"
Content-Disposition: attachment; 
	filename="cpufreq-call-nr_iowait_cpu-with-disabled-preemption.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9v0q7g30

VGhpcyBwYXRjaCBmaXggY29tcGxhaW4gZnJvbSBwcmVlbXB0aXZlIGRlYnVnCgpCVUc6IHVzaW5n
IHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBwcmVlbXB0aWJsZSBbMDAwMDAwMDBdIGNvZGU6IFMwNmNw
dXNwZWVkLzY1NQpjYWxsZXIgaXMgbnJfaW93YWl0X2NwdSsweDFhLzB4MzAKUGlkOiA2NTUsIGNv
bW06IFMwNmNwdXNwZWVkIE5vdCB0YWludGVkIDIuNi4zNC1xdW90YS1jbGVhbnVwcyAjNDYKQ2Fs
bCBUcmFjZToKIFs8ZmZmZmZmZmY4MTJkZTJhZT5dIGRlYnVnX3NtcF9wcm9jZXNzb3JfaWQrMHhj
Mi8weGRjCiBbPGZmZmZmZmZmODEwMmJhZWE+XSBucl9pb3dhaXRfY3B1KzB4MWEvMHgzMAogWzxm
ZmZmZmZmZjgxMDY3MWIzPl0gdXBkYXRlX3RzX3RpbWVfc3RhdHMrMHgzYy8weDc3CiBbPGZmZmZm
ZmZmODEwNjI4OTQ+XSA/IGt0aW1lX2dldCsweDVlLzB4OTgKIFs8ZmZmZmZmZmY4MTA2NzM3Yz5d
IGdldF9jcHVfaWRsZV90aW1lX3VzKzB4NDkvMHg2OAogWzxmZmZmZmZmZmEwMDRkNGQxPl0gZ2V0
X2NwdV9pZGxlX3RpbWUrMHgyMS8weGE5IFtjcHVmcmVxX29uZGVtYW5kXQogWzxmZmZmZmZmZmEw
MDRkYzdmPl0gY3B1ZnJlcV9nb3Zlcm5vcl9kYnMrMHhjZC8weDMxNiBbY3B1ZnJlcV9vbmRlbWFu
ZF0KIFs8ZmZmZmZmZmY4MTNkNmI0Nj5dIF9fY3B1ZnJlcV9nb3Zlcm5vcisweDg5LzB4YzcKIFs8
ZmZmZmZmZmY4MTNkNzkzNj5dIF9fY3B1ZnJlcV9zZXRfcG9saWN5KzB4MWFkLzB4MjI3CiBbPGZm
ZmZmZmZmODEzZDdkZWU+XSBzdG9yZV9zY2FsaW5nX2dvdmVybm9yKzB4MWEwLzB4MWU4CiBbPGZm
ZmZmZmZmODEzZDgwNTg+XSA/IGhhbmRsZV91cGRhdGUrMHgwLzB4MzgKClNpZ25lZC1vZmYtYnk6
IERtaXRyeSBNb25ha2hvdiA8ZG1vbmFraG92QHh4eHh4eHh4eHg+Ci0tLQogZHJpdmVycy9jcHVm
cmVxL2NwdWZyZXFfb25kZW1hbmQuYyB8ICAgIDcgKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVm
cmVxL2NwdWZyZXFfb25kZW1hbmQuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX29uZGVtYW5k
LmMKaW5kZXggZTEzMTQyMS4uYzFiMWE5NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2Nw
dWZyZXFfb25kZW1hbmQuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9vbmRlbWFuZC5j
CkBAIC0zNjMsNiArMzYzLDcgQEAgc3RhdGljIHNzaXplX3Qgc3RvcmVfaWdub3JlX25pY2VfbG9h
ZChzdHJ1Y3Qga29iamVjdCAqYSwgc3RydWN0IGF0dHJpYnV0ZSAqYiwKIAlkYnNfdHVuZXJzX2lu
cy5pZ25vcmVfbmljZSA9IGlucHV0OwogCiAJLyogd2UgbmVlZCB0byByZS1ldmFsdWF0ZSBwcmV2
X2NwdV9pZGxlICovCisJZ2V0X2NwdSgpOwogCWZvcl9lYWNoX29ubGluZV9jcHUoaikgewogCQlz
dHJ1Y3QgY3B1X2Ric19pbmZvX3MgKmRic19pbmZvOwogCQlkYnNfaW5mbyA9ICZwZXJfY3B1KG9k
X2NwdV9kYnNfaW5mbywgaik7CkBAIC0zNzIsNiArMzczLDcgQEAgc3RhdGljIHNzaXplX3Qgc3Rv
cmVfaWdub3JlX25pY2VfbG9hZChzdHJ1Y3Qga29iamVjdCAqYSwgc3RydWN0IGF0dHJpYnV0ZSAq
YiwKIAkJCWRic19pbmZvLT5wcmV2X2NwdV9uaWNlID0ga3N0YXRfY3B1KGopLmNwdXN0YXQubmlj
ZTsKIAogCX0KKwlwdXRfY3B1KCk7CiAJbXV0ZXhfdW5sb2NrKCZkYnNfbXV0ZXgpOwogCiAJcmV0
dXJuIGNvdW50OwpAQCAtNDkzLDkgKzQ5NSwxMCBAQCBzdGF0aWMgdm9pZCBkYnNfY2hlY2tfY3B1
KHN0cnVjdCBjcHVfZGJzX2luZm9fcyAqdGhpc19kYnNfaW5mbykKIAogCQlqX2Ric19pbmZvID0g
JnBlcl9jcHUob2RfY3B1X2Ric19pbmZvLCBqKTsKIAorCQlnZXRfY3B1KCk7CiAJCWN1cl9pZGxl
X3RpbWUgPSBnZXRfY3B1X2lkbGVfdGltZShqLCAmY3VyX3dhbGxfdGltZSk7CiAJCWN1cl9pb3dh
aXRfdGltZSA9IGdldF9jcHVfaW93YWl0X3RpbWUoaiwgJmN1cl93YWxsX3RpbWUpOwotCisJCXB1
dF9jcHUoKTsKIAkJd2FsbF90aW1lID0gKHVuc2lnbmVkIGludCkgY3B1dGltZTY0X3N1YihjdXJf
d2FsbF90aW1lLAogCQkJCWpfZGJzX2luZm8tPnByZXZfY3B1X3dhbGwpOwogCQlqX2Ric19pbmZv
LT5wcmV2X2NwdV93YWxsID0gY3VyX3dhbGxfdGltZTsKQEAgLTY5NSw2ICs2OTgsNyBAQCBzdGF0
aWMgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5
LAogCQl9CiAKIAkJZGJzX2VuYWJsZSsrOworCQlnZXRfY3B1KCk7CiAJCWZvcl9lYWNoX2NwdShq
LCBwb2xpY3ktPmNwdXMpIHsKIAkJCXN0cnVjdCBjcHVfZGJzX2luZm9fcyAqal9kYnNfaW5mbzsK
IAkJCWpfZGJzX2luZm8gPSAmcGVyX2NwdShvZF9jcHVfZGJzX2luZm8sIGopOwpAQCAtNzA4LDYg
KzcxMiw3IEBAIHN0YXRpYyBpbnQgY3B1ZnJlcV9nb3Zlcm5vcl9kYnMoc3RydWN0IGNwdWZyZXFf
cG9saWN5ICpwb2xpY3ksCiAJCQl9CiAJCX0KIAkJdGhpc19kYnNfaW5mby0+Y3B1ID0gY3B1Owor
CQlwdXRfY3B1KCk7CiAJCW9uZGVtYW5kX3Bvd2Vyc2F2ZV9iaWFzX2luaXRfY3B1KGNwdSk7CiAJ
CS8qCiAJCSAqIFN0YXJ0IHRoZSB0aW1lcnNjaGVkdWxlIHdvcmssIHdoZW4gdGhpcyBnb3Zlcm5v
cgotLSAKMS42LjYuMQoK
--0016367f9dd423a5500487df65e5--

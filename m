Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab1LOTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:16:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58802 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LOTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111215071901.GF14237@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	<alpine.LFD.2.02.1112141423380.3020@ionos>
	<alpine.LFD.2.02.1112142116540.3020@ionos>
	<CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	<87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
	<CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
	<20111215071901.GF14237@elte.hu>
Date: Thu, 15 Dec 2011 11:16:54 -0800
X-Google-Sender-Auth: -WmTWJnV_U3yV74rX84QZ_JC9Tc
Message-ID: <CAE9FiQXh8tiJ0Aa80uGJBiVv_3-rirMt1roQwZ3dBws-p0=j9A@mail.gmail.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5 machine
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: multipart/mixed; boundary=001636c92b3ad1c82c04b426533a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c92b3ad1c82c04b426533a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 14, 2011 at 11:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Wed, Dec 14, 2011 at 6:24 PM, Nikunj A Dadhania
>> <nikunj@linux.vnet.ibm.com> wrote:
>> >>
>> >> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabl=
ed?
>> > make oldconfig somehow skipped this!! I can see my previous kernel con=
fig
>> > having this enabled.
>>
>> looks like recent dmar table related DMAR changing cause that.
>
> Which one would that be? Perhaps:
>
> =A0 =A0 =A0iommu: Rename the DMAR and INTR_REMAP config options
>
> ? They then need to be fixed if it can be done sanely.

yes.

@@ -287,7 +287,7 @@ config SMP

 config X86_X2APIC
        bool "Support x2apic"
-       depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
+       depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
        ---help---
          This enables x2apic support on CPUs that have this feature.


renaming INTR_REMAP IRQ_REMAP cause that.

Attached patch should fix the problem.

Thanks

Yinghai

--001636c92b3ad1c82c04b426533a
Content-Type: text/x-patch; charset=US-ASCII; name="x2apic_select_irq_remap_again.patch"
Content-Disposition: attachment; 
	filename="x2apic_select_irq_remap_again.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw85geu80

W1BBVENIXSB4ODYsIHgyYXBpYzogc2VsZWN0IElSUV9SRU1BUCBpbnN0ZWFkIG9mIGRlcGVuZHMg
b24gaXQKCk5pa3VuaiBBIERhZGhhbmlhIGZvdW5kIG9uZSBYMzg1MCB4NSwgZm91bmQgbG90IG9m
IGFwaWMgd2llcmRuZXNzIHdpdGggMy4yLTNjNS4KCkl0IHR1cm5zIG91dCBtYWtlIG9sZGNvbmZp
ZyB3aWxsIGRpc2FibGUgeDJhcGljIGluIG5ldyBjb25maWcsIGl0IHdpbGwKbWFrZSB4MmFwaWMg
cHJlLWVuYWJsZWQgc3lzdGVtIGNvbmZ1c2VkLgoKSXQgaXMgY2F1c2VkIGJ5CnwgaW9tbXU6IFJl
bmFtZSB0aGUgRE1BUiBhbmQgSU5UUl9SRU1BUCBjb25maWcgb3B0aW9ucwoKd2hpY2ggcmVuYW1l
ZCBJTlRSX1JFTUFQIHRvIElSUV9SRU1BUC4KCkF0IHZlcnkgYmVnaW5uaW5nLCB3ZSBkbyB1c2Ug
c2VsZWN0IGluc3RlYWQgb2YgZGVwZW5kcywgYnV0CnwgICAgeDg2LCBpbnRlbC1pb21tdTogZml4
IFgyQVBJQyAmJiAhQUNQSSBidWlsZCBmYWlsdXJlCmNoYW5nZWQgc2VsZWN0IHRvIGRlcGVuZHMg
dG8gc29sdmUgIURNQVIgY29tcGlsaW5nIGVycm9yLgoKTm93IHdlIGhhdmUKfCBpb21tdS9jb3Jl
OiBGaXggYnVpbGQgd2l0aCBJTlRSX1JFTUFQPXkgJiYgQ09ORklHX0RNQVI9bgpha2Egc2VwZXJh
dGUgSU5UUl9SRU1BUCBhbmQgRE1BUiwgYW5kIG1ha2UgdGhlbSBzZWxlY3QgRE1BUl9UQUJMRQoK
U28gd2UgY291bGQgY2hhbmdlIGJhY2sgdG8gc2VsZWN0IHdpdGggb3V0IGNvbXBpbGluZyB3aXRo
ICFETUFSLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoK
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9hcmNoL3g4Ni9LY29uZmlnCmluZGV4IDlj
MWM1ZTAuLmY3ODZjYTYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L0tjb25maWcKKysrIGIvYXJjaC94
ODYvS2NvbmZpZwpAQCAtMjg2LDcgKzI4Niw4IEBAIGNvbmZpZyBTTVAKIAogY29uZmlnIFg4Nl9Y
MkFQSUMKIAlib29sICJTdXBwb3J0IHgyYXBpYyIKLQlkZXBlbmRzIG9uIFg4Nl9MT0NBTF9BUElD
ICYmIFg4Nl82NCAmJiBJUlFfUkVNQVAKKwlkZXBlbmRzIG9uIFg4Nl9MT0NBTF9BUElDICYmIFg4
Nl82NAorCXNlbGVjdCBJUlFfUkVNQVAKIAktLS1oZWxwLS0tCiAJICBUaGlzIGVuYWJsZXMgeDJh
cGljIHN1cHBvcnQgb24gQ1BVcyB0aGF0IGhhdmUgdGhpcyBmZWF0dXJlLgogCg==
--001636c92b3ad1c82c04b426533a--

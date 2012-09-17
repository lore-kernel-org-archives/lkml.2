Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2IQHmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:42:35 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:14027
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab2IQHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:42:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zzbb2dI98dI9371I1432Id6f1izz1202h1d1ah1d2ahzz17326ah8275bh5eeeKz2dh668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAHHEP-01-34S-02
X-M-MSG: 
Message-ID: <5056D420.80808@amd.com>
Date: Mon, 17 Sep 2012 09:41:20 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matthew Garret <mjg@redhat.com>
Subject: Re: [PATCH 2/8 v2] acpi-cpufreq: Add quirk to disable _PSD usage
 on all AMD CPUs
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com> <1346747289-8421-3-git-send-email-andre.przywara@amd.com> <CACJDEmrOoZ_azqTrtfoGC-O=H0V=AHy8VExoFYYPhbUUx+7UAg@mail.gmail.com>
In-Reply-To: <CACJDEmrOoZ_azqTrtfoGC-O=H0V=AHy8VExoFYYPhbUUx+7UAg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 01:20 PM, Konrad Rzeszutek Wilk wrote:
>
> On Sep 4, 2012 4:26 AM, "Andre Przywara" <andre.przywara@amd.com
> <mailto:andre.przywara@amd.com>> wrote:
>  >
>  > To workaround some Windows specific behavior, the ACPI _PSD table
>  > on AMD desktop boards advertises all cores as dependent, meaning
>  > that they all can only use the same P-state. acpi-cpufreq strictly
>  > obeys this description, instantiating one CPU only and symlinking
>  > the others. But the hardware can have distinct frequencies for each
>  > core and powernow-k8 did it that way.
>  > So, in order to use the hardware to its full potential and keep the
>  > original powernow-k8 behavior, lets override the _PSD table setting
>  > on AMD hardware.
>
> Can you tell on which motherboards this different freq on cores can be
> exposed?

Actually I think the motherboard is not the limiting factor here.
Per-core P-states are possible on AMD Family 10h and greater CPUs, so 
Phenoms/Barcelona and beyond. You may need an AM2+/AM3 board, though. 
Fam10h CPUs run in some older AM2-only boards, but the power-management 
capabilities may be limited here. This definitely applies to the voltage 
(single power plane only), but the older BIOS on these boards may limit 
the frequency switching also.

The actual reason for this patch is the (Fam10h) BKDG [1] recommendation 
in chapter 2.4.2.13.4 _PSD (P-State Dependency). There advertising only 
one possible P-state per package is recommended - for desktop CPUs 
(which are supposed to run Windows ;-)
This was to overcome some nasty interaction between the Windows 
scheduler and their version of the ondemand governor.

Regards,
Andre.

[1] http://support.amd.com/us/Processor_TechDocs/31116.pdf

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany


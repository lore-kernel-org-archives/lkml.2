Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2B0ITc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:19:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:16710 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2B0ITa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:3>);
	Mon, 27 Feb 2012 03:19:30 -0500
Message-Id: <4F4B4A9C0200007800074DE4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 27 Feb 2012 08:19:24 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <ke.yu@intel.com>, <kevin.tian@intel.com>, <lenb@kernel.org>,
        <xen-devel@lists.xensource.com>, <davej@redhat.com>,
        <cpufreq@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] processor passthru - upload _Cx and _Pxx data to
 hypervisor (v5).
References: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
 <4F47733E020000780007497D@nat28.tlf.novell.com>
 <20120225002136.GB26913@phenom.dumpdata.com>
In-Reply-To: <20120225002136.GB26913@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.02.12 at 01:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> But cpufreq != cpuidle != cpufreq governor, and they all are run by 
> different rules.
> The ondemand cpufreq governor for example runs a timer and calls the 
> appropiate cpufreq
> driver. So with these patches I posted we end up with a cpufreq driver in 
> the kernel
> and in Xen hypervisor - both of them trying to change Pstates. Not good (to 
> be fair,
> if powernow-k8/acpi-cpufreq would try it via WRMSR -  those would up being 
> trapped and
> ignored by the hypervisor. I am not sure about the outw though).

I'm not aware of any trapping that would be done on the I/O port here;
it could be added, though (i.e. the ports removed from the list of
allowed ports of Dom0 once they become known to the hypervisor).

> The pre-RFC version of this posted driver implemented a cpufreq governor that 
> was
> nop and for future work was going to make a hypercall to get the true 
> cpufreq value
> to report properly in /proc/cpuinfo - but I hadn't figured out a way to make 
> it be
> the default one dynamically.
> 
> Perhaps having xencommons do 
> echo "xen" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
> 
> And s/processor-passthru/cpufreq-xen/ would do it? That would eliminate the 
> [performance,
> ondemand,powersave,etc] cpufreq governors from calling into the cpufreq 
> drivers to alter P-states.

Except that you want this to be a cpufreq driver, not a governor.

Jan


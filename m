Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2GWUiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:38:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56560 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2GWUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:38:19 -0400
Message-ID: <500DB637.8000502@wwwdotorg.org>
Date: Mon, 23 Jul 2012 14:38:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Simon Glass <sjg@chromium.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH V2 3/3] tegra: add pwm backlight device tree nodes
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com> <1341814105-20690-4-git-send-email-acourbot@nvidia.com> <CAPnjgZ1QbjE+-tr0c01K2feUdEE2wMBfR=bKpTxnyDOJbY8+1Q@mail.gmail.com> <4FFEA2D4.9050308@nvidia.com> <CAPnjgZ2=Ga2P-40trA_=UABm=i7Uy4NTAM=ehea11mE22VfDew@mail.gmail.com> <4FFFB2DC.3040605@nvidia.com>
In-Reply-To: <4FFFB2DC.3040605@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 11:32 PM, Alex Courbot wrote:
> On 07/12/2012 11:27 PM, Simon Glass wrote
...
>>  From my understanding mixing strings and numbers in a property is
>> frowned on though.
> 
> But doesn't it make sense in the current case? The power sequence is
> basically a program that is run by an interpreter. From this
> perspective, it makes more sense to me to have it as a binary field
> rather than a hierarchy of nodes and properties that will be harder to
> parse and will make error detection more complicated. I don't really see
> any practical benefit from turning the steps into sub-nodes, but then
> again I am not so familiar with the DT.

Mixing strings and integers in a property isn't "allowed" (by convention
of DT bindings reviewers - as you noticed, dtc will happily compile it);
there are practical issues with attempting to do so, such as causing the
integer values to be unaligned, and thus causing the current integer
parsing code to fail, etc.

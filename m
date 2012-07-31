Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2GaQek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:34:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60708 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2GaQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:34:39 -0400
Message-ID: <5018091A.2020606@wwwdotorg.org>
Date: Tue, 31 Jul 2012 10:34:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com> <50170EA0.1010408@wwwdotorg.org> <5017B434.2010706@nvidia.com>
In-Reply-To: <5017B434.2010706@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:32 AM, Alex Courbot wrote:
> On 07/31/2012 07:45 AM, Stephen Warren wrote:
...
>> If the nodes have a unit address (i.e. end in "@n"), which they will
>> have to if all named "step" and there's more than one of them, then they
>> will need a matching reg property. Equally, the parent node will need
>> #address-cells and #size-cells too. So, the last couple lines would be:
>>
>>         power-on-sequence {
>>             #address-cells = <1>;
>>             #size-cells = <0>;
>>             step@0 {
>>                 reg = <0>;
> 
> That's precisely what I would like to avoid - I don't need the steps to
> be numbered and I certainly have no use for a reg property. Isn't there
> a way to make it simpler?

You may be able to get away without using the reg values in the code.
However, to have a semantically correct device tree, you really do need
all of those properties.

That said, I think you might need to use the reg values in code. I
believe there's no guarantee of the order in which nodes enumerate in
device tree, so you need to look at the reg property in order to find
the order in which to execute the nodes/steps.

... although perhaps the desire to avoid a dependency on DT ordering
applies more to the order in which devices instantiated from DT get
probed, rather than the order of low-level node enumeration, so I may be
wrong here. I've definitely seen Grant caution people not to rely on
device probe order, but perhaps he didn't make the same comment about
node order.

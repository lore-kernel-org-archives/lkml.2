Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab2HPVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:41:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030494Ab2HPVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:41:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH v4 0/3] Runtime Interpreted Power Sequences
Date: Thu, 16 Aug 2012 23:47:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208162347.34810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 16, 2012, Alexandre Courbot wrote:
> Overdue revision of this new feature, some changes required additional thought
> and rework.
> 
> The most important change is in the way power sequences are expressed in the
> device tree. In order to avoid having to specify #address-cells, #size-cells and
> reg properties, the @ notation in the step names is dropped, and instead a
> fixed, sequential naming is adopted. The type of the resource used by a step is
> decided by the presence of some recognized properties:
> 
> power-on-sequence {
> 	step0 {
> 		regulator = "power";
> 		enable;
> 	};
> 	step1 {
> 		delay = <10000>;
> 	};
> 	step2 {
> 		pwm = "backlight";
> 		enable;
> 	};
> 	...
> 
> To me this looks safe, clear and close to the platform data representation, but
> needs approval from DT experts.
> 
> Resources are still referenced by name instead of having their phandles defined
> directly inside the sequences, as previous discussion came to the conclusion
> that doing so would require controversial changes to the regulator and PWM
> frameworks, and that having the resources declared at the device level was
> making sense logically speaking.
> 
> Other changes/fixes since last revision:
> * Move to drivers/power/ (hope this is ok with the maintainers?)
> * Use microseconds for delay
> * Use devm for PWM resources and remove cleanup function as all resources are
>   devm-managed
> * Remove "-gpio" suffix for GPIO reference in the driver
> * Remove params structure
> * Make power_seq structure private
> * Number of steps in a sequence is explicitly stated instead of resorting to a
>   "stop" sequence step
> * Delays are a step instead of being a step parameter
> * Use flexible member arrays to limit number of memory allocations
> * Add documentation to DT bindings
> 
> There was a lot of feedback on the previous version (thanks!) so if I forgot
> to address some important point, please bring it to my attention again.
> 
> Alexandre Courbot (3):
>   Runtime Interpreted Power Sequences
>   pwm_backlight: use power sequences
>   tegra: add pwm backlight device tree nodes

May I ask that the next version of this patchset be CCed to
linux-pm@vger.kernel.org?

Thanks,
Rafael

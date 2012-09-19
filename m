Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2ISPZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:25:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58604 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2ISPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:25:23 -0400
Message-ID: <5059E3DF.6020906@wwwdotorg.org>
Date: Wed, 19 Sep 2012 09:25:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: Document general interrupt controller bindings
References: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 02:57 AM, Thierry Reding wrote:
> In order to use a device as interrupt controller, it needs to be marked
> with the DT interrupt-controller property. This commit adds rudimentary
> documentation about the required standard properties and describes the
> most commonly used interrupt specifiers.

> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -0,0 +1,94 @@
> +Specifying interrupt information for devices
> +============================================
> +
> +1) Interrupt user nodes
> +-----------------------

s/user/client/? Bike-shedding a little I suppose.

> +
> +A device that generates interrupts can specify the interrupt controller to
> +which the interrupts are routed by passing the controller's phandle in the
> +"interrupt-parent" property.
> +
> +The "interrupts" property is a list of specifiers that describe each of the
> +interrupts. See section 2 below for details.

This should probably mention that interrupt-parent cascades from parent
nodes. How about the following instead:

Nodes that describe devices which generate interrupts must contain an
"interrupts" property. This property must contain a list of interrupt
specifiers, one per output interrupt. The format of the interrupt
specifier is determined by the interrupt controller to which the
interrupts are routed; see section 2 below for details.

The interrupt-parent property is used to define the controller to which
interrupts are routed; it contains a single phandle referring to the
interrupt controller node. This property may be specified in any
interrupt client node, or in any parent node of the device.

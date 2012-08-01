Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2HAJeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:34:08 -0400
Received: from smtp-out-180.synserver.de ([212.40.185.180]:1067 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752936Ab2HAJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:34:06 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8130
Message-ID: <5018F908.9090607@metafoo.de>
Date: Wed, 01 Aug 2012 11:38:16 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
References: <20120731151600.GA19412@redhat.com> <20120731170741.GA4735@x1.osrc.amd.com> <20120731172638.GE16873@home.goodmis.org> <20120731174249.GB4735@x1.osrc.amd.com> <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de> <20120801085644.GA21303@liondog.tnic> <5018F537.209@metafoo.de> <20120801092625.GB21303@liondog.tnic>
In-Reply-To: <20120801092625.GB21303@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 11:26 AM, Borislav Petkov wrote:
> On Wed, Aug 01, 2012 at 11:21:59AM +0200, Lars-Peter Clausen wrote:
>> One major reason for the new PWM framework is to be able to support
>> arch independent PWM drivers, like those for companion chips with PWM
>> capabilities. Restricting the config option to certain architectures
>> wouldn't work.
> 
> Right,
> 
> but when I enable the CONFIG_PWM option on x86, I don't see any drivers
> there. So the logical thing to do would be to hide that option on arches
> which don't have such chips.

You don't see any drivers, because the subsystem is still young and no such
arch independent drivers have been added yet, but they will get added in the
future. The arch independent companion or PWM expander chips usually
interface via I2S or SPI and I would consider it quite likely that you'll
also find them on some embedded X86 boards. If we add a arch restriction to
the config item now we'd quite likely have to remove it again in the next
release.


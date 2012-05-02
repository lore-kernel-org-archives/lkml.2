Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2EBV42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:56:28 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3460 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab2EBV40 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:56:26 -0400
Message-ID: <1335995781.30754.27.camel@x61.thuisdomein>
Subject: Re: [v3.4-rc5]: drm references experimental
From: Paul Bolle <pebolle@tiscali.nl>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 May 2012 23:56:21 +0200
In-Reply-To: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
References: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-OriginalArrivalTime: 02 May 2012 21:56:21.0486 (UTC) FILETIME=[690358E0:01CD28AE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 16:31 +0200, Jörg Otte wrote:
> there is a dependency between drm and experimental driver. If I
> don't enable EXPERIMENTAL I see the following during configuration:
> 
> warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct
> dependencies (EXPERIMENTAL)
> 
> I think non-experimental code shouldn't depend on experimental code.

This reminds me of a brief discussion on the merits of EXPERIMENTAL
starting at https://lkml.org/lkml/2012/1/18/385 . My impression from
that discussion was that EXPERIMENTAL currently is set in most
configurations (eg, even Debian stable has EXPERIMENTAL set). This means
that people generally won't notice that an option that itself doesn't
depend (indirectly) on EXPERIMENTAL selects an option that does depend
directly on EXPERIMENTAL. So, yes, one wouldn't expect non-EXPERIMENTAL
code to use EXPERIMENTAL code but, apparently, in practice it does.

I also noticed that there's not a single instance of CONFIG_EXPERIMENTAL
in any code-file or in any Makefile. EXPERIMENTAL is only relevant in,
well, Kconfig space. That should make it somewhat less likely that there
are surprising changes to the code than in other cases of options
selecting options with unmet direct dependencies.


Paul Bolle


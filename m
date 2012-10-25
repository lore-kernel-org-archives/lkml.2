Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2JYOSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:18:13 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:47991 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab2JYOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <50893C45.7010109@gmail.com>
References: <425b4bec021bce9a2de49959121907aeede6a0b9.1350064805.git.viresh.kumar@linaro.org>
	<CAKohpom42SCMJ+=TdvAjqT0ibRugJi_gXkLy+49N6ExcRZqxLQ@mail.gmail.com>
	<50893C45.7010109@gmail.com>
Date: Thu, 25 Oct 2012 19:48:09 +0530
Message-ID: <CAKohpom5QmO5vbREsMgi4EefLpBxXsk=QWVaZwTwC_Knf72GVA@mail.gmail.com>
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: grant.likely@secretlab.ca, spear-devel@list.st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 18:49, Rob Herring <robherring2@gmail.com> wrote:
> For some reason, this does not show up on the list either in my mail or
> mail list archives, but it is in patchwork. Can you resend it please.

Strange. I kept you in --to field. I know people added in cc are
sometimes removed
by the list when they have selected "avoid duplicate mails" option for
their list.

> The main question I have is be32_to_cpup() the right thing to do. I
> would expect byte arrays to not need endian conversion, but I haven't
> looked at how '/bits/ x' data is stored.

The problem i see here is:

The data passed via DT comes as Little Endian in the kernel.

For a little endian system, byte zero will contain the data and so
(u8) val

look to be the correct thing.

For a big endian system, byte 3 will contain data as it is swapped by
be32_to_cpup.
So (u8) val would return value stored by byte 0 instead. ??

Does my logic look correct to you??

--
viresh

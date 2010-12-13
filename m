Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0LMWzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:55:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0LMWzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LXAW+UfEPmERJEn8WgykES0z/tsiqPY/+HJTBSNB+ffjU9x3LrdPhRSJxeO3APE8LO
         PsqWcvHTTHd9PmN+uf6A==
MIME-Version: 1.0
In-Reply-To: <20101213135110.GL8665@n2100.arm.linux.org.uk>
References: <1290039615-23407-1-git-send-email-ccross@android.com>
	<20101213135110.GL8665@n2100.arm.linux.org.uk>
Date: Mon, 13 Dec 2010 14:55:47 -0800
X-Google-Sender-Auth: 8bL9eV-M5WQVjmVHbPU9ZRC_yQU
Message-ID: <AANLkTinsELGgMFoVmTZuLPgaMCF5h0fos6u44z9VapHs@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: timer: Separate clocksource and sched_clock
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 5:51 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 17, 2010 at 04:20:15PM -0800, Colin Cross wrote:
>> tegra_clocksource_read should not use cnt32_to_63, wrapping is
>> already handled in the clocksource code.  Move the cnt32_to_63
>> into the sched_clock function, and replace the use of clocksource
>> mult and shift with a multiplication by 1000 to convert us to ns.
>
> Colin,
>
> Mind if I pick this up into my tree - I'm doing other work with
> clocksources and sched_clock() at the moment which will clash with
> this patch.

Sure, I'll need to coordinate the Tegra tree with your tree already
because of the GIC and SMP changes.

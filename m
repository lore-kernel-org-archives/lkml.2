Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2ESVAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:00:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33123 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2ESVAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120519205400.GB16590@opensource.wolfsonmicro.com>
References: <1337428920-7674-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120519202258.D9B903E03B8@localhost> <20120519205400.GB16590@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 19 May 2012 14:59:51 -0600
X-Google-Sender-Auth: UiJg-8Z9W5LHjr-FPB4yj3kJoMQ
Message-ID: <CACxGe6vqzOyeLf8okuo2OdTFUaB_E=5KFSN11n05vgEyJzpmBQ@mail.gmail.com>
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 2:54 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, May 19, 2012 at 02:22:58PM -0600, Grant Likely wrote:
>
>> I'm looking at killing the legacy mapping entirely which will push
>> changing all the users anyway.  I'm going to hold off on applying this
>> one for a day or so until I'm sure of what it will look like.
>
> I take it you're going to replace the legacy mapping with an equivalent
> thing, though, so the interface is preserved for boards?  In which case
> it'd be more like replacing the linear mapping with a new mapping type
> that can also be used by legacy users I guess?

It will actually be like all legacy users switched to creating an
linear mapping, and then either associating already allocated
irq_descs with that domain or telling the domain to pre-map a specific
range of irq_descs (and manage allocations).  Those two use cases will
be separate APIs.  I don't think they should be combined (at least
from my current thinking) because it depends on whether or not the
irq_descs are already allocated.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

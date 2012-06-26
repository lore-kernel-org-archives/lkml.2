Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2FZKkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:40:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49076 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab2FZKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:40:31 -0400
Date: Tue, 26 Jun 2012 11:40:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: core: Only delay if we successfully set
 the voltage
Message-ID: <20120626104028.GO30406@opensource.wolfsonmicro.com>
References: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAF+7xWkj+aFc_Kq7PzAoYrUa0tCs1sq7K2=bc-tVXJH4x+7DRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF+7xWkj+aFc_Kq7PzAoYrUa0tCs1sq7K2=bc-tVXJH4x+7DRw@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 06:30:16PM +0800, Axel Lin wrote:

> >        /* Call set_voltage_time_sel if successfully obtained old_selector */
> > -       if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
>                                                                   ^^^^^^^^
>                                                                  We
> already check ret ==0 here.

Your mailer is seriously messing up your formatting - the indentation is
nothing to do with what you're trying to point at...

The checks do need to be reordered here, though - we should check the
return value first.

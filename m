Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1INX1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 19:27:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077Ab1INX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:27:09 -0400
Date: Thu, 15 Sep 2011 00:27:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regulator constraints and userspace consumer
Message-ID: <20110914232706.GB2953@opensource.wolfsonmicro.com>
References: <CAM8FrKKEXUwV6=cMzqi0Le7eadb2XWkrjSQ+jm=QBUJMGPKztQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM8FrKKEXUwV6=cMzqi0Le7eadb2XWkrjSQ+jm=QBUJMGPKztQ@mail.gmail.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 08:54:47PM +0200, Marcus Folkesson wrote:

>   What is the most accurate way to set the voltage for these
> limitations when the system starts up? There is apparently no check if
> the default configuration is within limits as the regulator stays on
> 1125mV.
>   When I'm looking in the userspace consumer (/sys/class/regulator/),
> the "max_microvolts" and "min_microvolts" is set to 1000000 but the
> "microvolts" is set to 1125000.

Set apply_uV in hte constraints.  The regulator framework won't touch
the hardware unless explicitly told to.

> * I want to change the output voltage from userspace on demand. What
> is the most proper way to do this? If I have understand correctly, the
> userspace consumer just exports interface for switching on/off the
> regulator, is that correct?

Why do you wish to do this?  In general this is not a good sign.  There
is the virtual consumer but that is explicitly intended for test, it's
not really supposed to be used in production.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1DTQp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:45:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1DTQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:45:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Date: Wed, 20 Apr 2011 18:44:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201844.30919.arnd@arndb.de>
X-Provags-ID: V02:K0:pu4gZyy7Q++HDjppajM/SM7WDhO9Ce+/Un8IAxFIaP/
 bvMeQMAznyEteynuTbukrawhYwXdDQO7spPREsHf1bOnh5TRsT
 J94XmMYzK+Q11ZP00ZokXp1cUAQeXNh4IiatjAJErE2UBndK0j
 rJAnygAILWF5kqv34qYrEofHgsYCvX0obVdChL/gYxlreWy75L
 l0D5LMge6bNpbJEgglmuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Guenter Roeck wrote:
> This driver adds support for Si570, Si571, Si598, and Si599
> programmable XO/VCXO.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

This needs some more explanation of what the hardware is there for,
and why it's unlike everything else that we support in Linux.

We try not to have too many things in drivers/misc that are
one-off interfaces, so if the hardware is related to something
else, it should probably go into one subsystem.

My impression from readin the source code is that this is
simply a clock device that would be used in combination with
some other device in practice that consumes the clock.
If that is true, it should probably not have a user-visible
interface, but only an interface that can be used by other
kernel drivers.

	Arnd

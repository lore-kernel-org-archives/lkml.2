Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab3AIMjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:39:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42738 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3AIMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:39:07 -0500
Date: Wed, 9 Jan 2013 12:38:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Message-ID: <20130109123853.GJ3931@n2100.arm.linux.org.uk>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org> <1357725965-27342-2-git-send-email-lee.jones@linaro.org> <201301091018.55058.arnd@arndb.de> <20130109103510.GE3931@n2100.arm.linux.org.uk> <20130109110840.GD31678@gmail.com> <20130109111209.GH3931@n2100.arm.linux.org.uk> <20130109122323.GE31678@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109122323.GE31678@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:23:23PM +0000, Lee Jones wrote:
> Excuse my ignorance, but I'm a little confused by this.
> 
> What's the difference between 'select <OPTION>' in the Kconfig and
> 'CONFIG_<OPTION>=y' in the defconfig; besides the fact that if we
> do it in the Kconfig file, we can be more selective with regards to
> which platform it gets enabled on?

Take this in Kconfig:

config FOO
	bool "FOO option"
	select BAR

config BAR
	bool "BAR option"

Now, irrespective of the default configuration file being used:
- if you don't enable FOO, then you can enable _and_ _disable_ BAR according
  to your needs.
- if you enable FOO, then BAR will be _forcefully_ enabled and you can't
  turn it off without first disabling FOO.

The default configuration file will specify the _default_ values for these
options, but if FOO ends up being enabled, BAR will be forcefully enabled
irrespective of what's in the configuration file.

With this instead:

config FOO
	bool "FOO option"

config BAR
	bool "BAR option"

Then, the two options are independent.  They can be enabled and disabled
by the configuration completely independently.  However, their default
values come from the default configuration file.  So, if the config file
has:

CONFIG_FOO=y
CONFIG_BAR=y

and you do a 'make oldconfig' then they will remain set.  If you use one
of the configuration editing tools, you'll be presented with them already
enabled, and you can turn them off independently.

So, putting this stuff in the default configuration file allows
_non-mandatory_ options to be disabled should the user desire without the
user having to edit the configuration files.

If a user has to edit the configuration files in order to configure the
kernel as they desire, then the configuration system has failed - or we
have failed to properly think out how to represent the allowable
configurations.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab0EZLfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:35:33 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:42878 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934427Ab0EZLfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:35:30 -0400
Date: Wed, 26 May 2010 13:35:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCMCIA regression
Message-ID: <20100526113515.GA7219@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, May 25, 2010 at 04:25:21PM -0400, Mikulas Patocka wrote:
> The commit a8408c17d0038b76a83affb1b56dc18fa1e7ed86 in Linux 2.6.34-rc6 
> broke pcmcia for me. I use 3c574 network card in yenta socket on Armada 
> 7400 laptop. My distribution is Debian lenny.
> 
> Reverting the test for "s->functions" in pccard_validate_cis makes the 
> network card work again.

Does this warning appear during reume, or during some other "special" use
case? Also, does commit cc83b08fc791045ac197e6f4a030599bcd7100c5 solve this
issue? If not: Could you enable dynamic debug logging via

# mount debugfs
mount none -t debugfs /sys/kernel/debug/

# enable debug
echo "module pcmcia +p" > /sys/kernel/debug/dynamic_debug/control
echo "module pcmcia_core +p" > /sys/kernel/debug/dynamic_debug/control
echo "module yenta_socket +p" > /sys/kernel/debug/dynamic_debug/control

and send me the resulting log (which may be looong).

Thanks,
	Dominik

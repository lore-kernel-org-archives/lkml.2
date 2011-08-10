Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1HJMsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:48:17 -0400
Received: from mail.solarflare.com ([216.237.3.220]:5294 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1HJMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:48:16 -0400
Subject: Re: BUG: Bisected Gianfar in bridge not forwarding packets (was:
 3.0-rc1 Bridge not forwarding unicast packages)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Michael Guntsche <mguntsche@gmail.com>
Cc: Jiri Pirko <jpirko@redhat.com>, shemminger@vyatta.com,
        sebastian.belden@googlemail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <CAMvAeqOZ9OoV5KxTbn0+sPxJ=AkSrb__31GShVshDkX6NUXgNw@mail.gmail.com>
References: <CAMvAeqOA0=FnjB2oPPCEYpkXdKrmqOs+MwAqszV5sTGys_a3mQ@mail.gmail.com>
	 <20110810090014.GB1909@minipsycho.brq.redhat.com>
	 <CAMvAeqO2bLaPwmdW+c+7hz-ec=-tF6Z0EFBv=FA7+rU_QZ_wDA@mail.gmail.com>
	 <CAMvAeqM-oH1UzxEp9PgO6ZP-AKtqosuMg5za25_X8DpPJMDX2w@mail.gmail.com>
	 <20110810111947.GC1909@minipsycho.brq.redhat.com>
	 <CAMvAeqOZ9OoV5KxTbn0+sPxJ=AkSrb__31GShVshDkX6NUXgNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 10 Aug 2011 13:48:12 +0100
Message-ID: <1312980492.2591.1261.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 12:48:15.0666 (UTC) FILETIME=[C5A7F120:01CC575B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18314.005
X-TM-AS-Result: No--15.479900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 13:51 +0200, Michael Guntsche wrote:
[...]
> Jiri, there seems to be another bug lingering in the bridge code,
> which might cause this problem in the first place but I am not really
> sure. I looked at the ethtool output some more and I noticed that some
> features were enabled on the Bridge which should be off.
[...]

That's an intentional change.  There are software fallbacks for TX
checksumming and VLAN tag insertion.  Bridge devices (and some other
software devices) now always advertise them so that the fallback is not
used until and unless it is known that the real output device doesn't
support the feature.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


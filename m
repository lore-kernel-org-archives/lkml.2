Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2CLGbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:31:35 -0400
Received: from 1wt.eu ([62.212.114.60]:63145 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab2CLGb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:31:28 -0400
Date: Mon, 12 Mar 2012 07:31:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pavel Roskin <proski@gnu.org>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
Message-ID: <20120312063108.GC8971@1wt.eu>
References: <20120312002046.282831520@1wt.eu> <1331517472.3022.150.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331517472.3022.150.camel@deadeye>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 01:57:52AM +0000, Ben Hutchings wrote:
> On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> > 
> > commit 8617b093d0031837a7be9b32bc674580cfb5f6b5 upstream.
> > 
> > rate control algorithms concludes the rate as invalid
> > with rate[i].idx < -1 , while they do also check for rate[i].count is
> > non-zero. it would be safer to zero initialize the 'count' field.
> > recently we had a ath9k rate control crash where the ath9k rate control
> > in ath_tx_status assumed to check only for rate[i].count being non-zero
> > in one instance and ended up in using invalid rate index for
> > 'connection monitoring NULL func frames' which eventually lead to the crash.
> > thanks to Pavel Roskin for fixing it and finding the root cause.
> > https://bugzilla.redhat.com/show_bug.cgi?id=768639
> 
> In 2.6.32, ath_tx_status() checks that rates[i].idx >= 0, so it properly
> ignores these dummy entries.  Further, there is code further down the
> rate_control_get_rate() function that sets .idx only and appears to
> depend on the initialisation of .count = 1.
> 
> So I'm pretty sure this patch is wrong for 2.6.32; it could be
> backported but I don't think the change is necessary anyway.

Dropping it then, thanks Ben !

Willy


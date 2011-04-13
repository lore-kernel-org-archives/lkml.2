Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab1DMQDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:03:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:43513 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab1DMQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:03:42 -0400
Message-ID: <4DA5C95B.6000706@trash.net>
Date: Wed, 13 Apr 2011 18:03:39 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Sterba <dsterba@suse.cz>
Subject: Re: [49/74] netfilter: h323: bug in parsing of ASN1 SEQOF field
References: <20110413155148.210947709@clark.kroah.org>
In-Reply-To: <20110413155148.210947709@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.04.2011 17:51, schrieb Greg KH:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: David Sterba <dsterba@suse.cz>
> 
> commit b4232a22776aa5d063f890d21ca69870dbbe431b upstream.
> 
> Static analyzer of clang found a dead store which appears to be a bug in
> reading count of items in SEQOF field, only the lower byte of word is
> stored. This may lead to corrupted read and communication shutdown.
> 
> The bug has been in the module since it's first inclusion into linux
> kernel.
> 
> [Patrick: the bug is real, but without practical consequence since the
>  largest amount of sequence-of members we parse is 30.]

As mentioned in the changelog, I don't think this patch is of any
relevance for -stable since its a purely theoretical problem.

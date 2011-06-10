Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1FJF4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:56:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56613 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1FJF4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kvsyvnleiBBZ9YU4tX8qsqsnSu8r6t0PJYorh57UZc9bFhb07zfe3GRkKu219Cbfdw
         vCHCyGjDmQlJLIJzgDdXASKeiofRF/kx6Bro3jiHDrqBNGv5W7p9fWKu5xJ0iwlMGuyh
         WOO9vtzOUaApFZx5zaL3BmdDBDhQT/iFCnh9A=
Date: Fri, 10 Jun 2011 14:55:58 +0900
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Waldemar.Rymarkiewicz@tieto.com
Cc: keithp@keithp.com, padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Message-ID: <20110610055558.GA1832@dell>
Mail-Followup-To: Waldemar.Rymarkiewicz@tieto.com, keithp@keithp.com,
	padovan@profusion.mobi, marcel@holtmann.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <yunboy7a2so.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
 <20110609083345.GA2894@dell.ccr.corp.intel.com>
 <yuny61b3pnm.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 09, 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >I re-pair'ed using a manually entered a 16 digit pin, but now 
> >DUN setup doesn't succeed at all.
> 
> Did you try to remove all stored link keys and start again?
> If you already have a pincode which is insecure you have to remove it manually.
> 
> Try 'hciconfig hciX noauth noencrypt ' before.
> 
> Check syslog and switch debug on in the kernel first.

So I just realized that the BITE tests were only done for mgmtops.c and
not hciops.c. One critical difference is that conn->key_type will not be
set (or actually set to 0xff) for connections which happen after the
initial pairing has occurred. We're right now testing a one-line patch
which might fix the issue. Luiz will send it soon if it turns out to
work fine.

Johan

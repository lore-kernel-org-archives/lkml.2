Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1CUPBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:01:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51994 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1CUPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=P/fsCwsth5Dzhw5QkiTXUHDiL6FyI3R8/Omv99DAUuWq1B345OFUKHGVmZ2sMfbHG/
         VzX9d2Qooh75gFt3SdxKcIZNqEePW987Rsbq/I9utyOBXXNMeZWwrxQa6ucR5pHh14NC
         WCHjzTLOLvDVd7kxdT2xgb6WTHLj5yUIYx58w=
Date: Mon, 21 Mar 2011 17:59:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] rapidio: potential null deref on failure path
Message-ID: <20110321145948.GP2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110319044032.GC2008@bicker>
 <0CE8B6BE3C4AD74AB97D9D29BD24E55201A588F5@CORPEXCH1.na.ads.idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201A588F5@CORPEXCH1.na.ads.idt.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:49:06AM -0700, Bounine, Alexandre wrote:
> Better to combine both conditions:
> 
> if (rio_is_switch(rdev) && rswitch->route_table))
>  		kfree(rswitch->route_table);
> 
> Because there is situation when routine fails to allocate route_table
> for a switch.
> 

kfree() accepts NULL pointers.  People have been removing these checks
all over the tree by the hundreds...  Sorry I should have mentioned 
that.

regards,
dan carpenter



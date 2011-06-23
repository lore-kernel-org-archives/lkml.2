Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1FWUMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:12:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40091 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab1FWUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:12:37 -0400
MIME-Version: 1.0
In-Reply-To: <1308847113-5953-1-git-send-email-robherring2@gmail.com>
References: <1308847113-5953-1-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 23 Jun 2011 14:12:17 -0600
X-Google-Sender-Auth: JTuGbeXS7JHV7HWEOH4ifiS2PYc
Message-ID: <BANLkTi=5Pbg6x3rf-4Z3QxbUnaKddad3Zw@mail.gmail.com>
Subject: Re: [PATCH] dt: add of_get_property_value32 helper function
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:38 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> A common use of of_get_property in driver is to just get a 32-bit integer
> value, but the interface is a bit complicated in that case. Add a helper
> function that just fills in the value.

Hey Rob,

I already asked Thomas Abraham to write a patch that does exactly
this.  He's already posted his first draft to the list.  His version
also covers u64 and strings, so I'm going to let him respin his
version and pick that one up.

> Grant,
>
> I noticed most callers of of_get_property don't do be32_to_cpup on the
> returned pointer. Most instances appear to be powerpc only drivers, but
> should of_get_property return ptr be __be32?

No.  Not all properties contain cell values.  Having of_get_property
return void* is the correct behaviour.

g.

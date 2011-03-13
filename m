Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1CMRVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:21:33 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54292 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1CMRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=aELqBJawFzFA6IMKwpH3NZHCCG6puy6obNT24mxdM15JUrtwp29GEz9yRHonuZwOc/
         nq6k/0H3jCdiHKnGHrLybxYXVKHdeGIOALiadrw/bqJ7gmwB4tg+rST4R5cADRMr4pX5
         K3MeeisEnvaj/2afEpJcSZxOvBr8toT4PHC4Y=
Message-ID: <4D7CFD11.5020604@linaro.org>
Date: Sun, 13 Mar 2011 17:21:21 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131351.36078.rjw@sisk.pl> <4D7CCC4D.801@linaro.org> <201103131758.47663.rjw@sisk.pl>
In-Reply-To: <201103131758.47663.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 04:58 PM, Somebody in the thread at some point said:

> So, you want to have a mechanism telling the driver "if the device
> happens to have this particular path, use that platform data", right?

Yeah.

> And it works because the initialization code kind of knows what path the
> device is going to be at, so it can predict that and provide the mathing data.
>
> Unfortunately, this relies on how device paths are constructed at the moment,
> so if this approach is adopted in general, it will prevent us from changing
> that way in the future (or at least it will make that very difficult).
>
> Perhaps you could use some other kind of device identification here?

I'm sorry what prevents you changing paths in the future?

Nothing does, if you change the bus tag from like usb1 to UsB_1 you just 
fix up the strings in the board definition files at the same time, they 
are sitting there in the same tree and

  grep platform_async_platform_data arch/* -R

will show them all up in one hit.  It's no different if you changed the 
name of a driver, you'd patch the board definition files with devices 
that need to bind to that driver name to uplevel them to the new name.

The board definition file for these SoC cases usually has access to a 
pointer to the host controller directly since it instantiates them, if 
this was the only stumbling point and you thought it helped something 
the matching system can look for that particular pointer being a parent 
of the candidate probed device.

-Andy

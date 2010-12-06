Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0LFUKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:10:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab0LFUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:10:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XZzS8/x7Ts+TWGcmKKqFHfnUssIbM0v2WaQszi3PS6aHiqDQRUKGJtr4DTv64qUJ2W
         c2E5aiVtDCf3MsXequyOTHs9Zi5aHEZphuaTJHfWVhnhkjWSHINnOTyWGQA6IO/6+hMb
         9nD+BXcT1P1sO5+k9zS1HnXpmighhHYPGKg6o=
Date: Mon, 6 Dec 2010 22:10:08 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/45] kstrtox: convert drivers/isdn/
Message-ID: <20101206201008.GA5650@core2.telecom.by>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
 <1291571382-2719-26-git-send-email-adobriyan@gmail.com>
 <4CFC2A05.7010509@phoenixsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFC2A05.7010509@phoenixsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 01:10:45AM +0100, Tilman Schmidt wrote:
> I like the patch, but why not go all the way?
> 
> Am 05.12.2010 18:49 schrieb Alexey Dobriyan:
> > @@ -566,10 +566,10 @@ void gigaset_handle_modem_response(struct cardstate *cs)
> >  		case RT_ZCAU:
> >  			event->parameter = -1;
> >  			if (curarg + 1 < params) {
> > -				unsigned long type, value;
> > +				u8 type, value;
> >  
> > -				i = strict_strtoul(argv[curarg++], 16, &type);
> > -				j = strict_strtoul(argv[curarg++], 16, &value);
> > +				i = kstrtou8(argv[curarg++], 16, &type);
> > +				j = kstrtou8(argv[curarg++], 16, &value);
> >  
> >  				if (i == 0 && type < 256 &&
> >  				    j == 0 && value < 256)
> 
> Once type and value are u8, the checks for < 256 are unnecessary.

OK.

> > @@ -583,7 +583,7 @@ void gigaset_handle_modem_response(struct cardstate *cs)
> >  				unsigned long res;
> >  				int rc;
> >  
> > -				rc = strict_strtoul(argv[curarg++], 10, &res);
> > +				rc = kstrtoul(argv[curarg++], 10, &res);
> >  				if (rc == 0)
> >  					event->parameter = res;
> >  			}
> 
> The new kstrtoul() promises not to touch the result field in the event
> of a conversion error, so &event->parameter can be passed directly to
> it, getting rid of the variables rc and res and the if statement.

What should be done in case of error?
Compiler will warn if kstrto*() result is unused:

	kstrtoul(argv[curarg++], 10, &event->parameter);

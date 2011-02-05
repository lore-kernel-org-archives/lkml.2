Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1BEOkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:40:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56553 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1BEOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=A7rIuOOeqE43Y9bUvWcgtmqFXcQFMs2ROsfhCIhssAlpgD8Dq7c42n9S3kErHC7fnl
         jhIUZ+5Fb0ZqXCFzYpcmQe8AZLCoCozPzOPcEzt6ZszoPAfTDSd7qyFL/01E/aTbVIxc
         gH/IpTbFM3IDMe++qlI5bMhbW6Hy46YfCIZdE=
Date: Sat, 5 Feb 2011 16:40:04 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/52] kstrtox: converting strings to integers done
 (hopefully) right
Message-ID: <20110205144004.GB9814@p183.telecom.by>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
 <AANLkTimA3NLZsDwOp14A7KbGuUkHR3MFeLR7rQPVhLHG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimA3NLZsDwOp14A7KbGuUkHR3MFeLR7rQPVhLHG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 03:33:41PM +0100, Geert Uytterhoeven wrote:
> On Sat, Feb 5, 2011 at 15:20, Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > + * Convert integer string representation to an integer.
> > + * If an integer doesn't fit into specified type, -E is returned.
> 
> Which -E? Currently it returns -EINVAL everywhere.

Comment meant function follows 0/-E idiom for return value.

> > +       if (tmp != (unsigned long long)(unsigned long)tmp)
> > +               return -EINVAL;
> 
> -ERANGE for out-of-range?

Hmm, interesting.
It should prevent -EINVAL hardcoding.

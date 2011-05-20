Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544Ab1ETAr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:47:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64010 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1ETAr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o6bPSzaoAJEd82yXCmkldlo4+4+huuJSTQALq2TPtWIoHMvXbPVJb6xD+Lfi8dichR
         fP/E6yUm0JO9PNbV5hSjM8LAfJPtikIsCiT8pQNRf/I5sAONV5eQOyrcQPY0xdVVaf48
         8zHhWqhbjPgwx2ZzDCQJszRpTIj+sJVF+JgqE=
MIME-Version: 1.0
In-Reply-To: <1305851769.7481.90.camel@pasglop>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-5-git-send-email-ericvh@gmail.com>
	<1305851769.7481.90.camel@pasglop>
Date: Thu, 19 May 2011 19:47:55 -0500
Message-ID: <BANLkTimc3jQTOJdqAiqbPxGQNVWe39VqfQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 7:36 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
>>
>> -#ifdef CONFIG_NOT_COHERENT_CACHE
>> +#if defined(CONFIG_NOT_COHERENT_CACHE) || defined(CONFIG_BGP)
>>  #define ARCH_DMA_MINALIGN    L1_CACHE_BYTES
>>  #endif
>
> Is DMA cache coherent on BG/P ? That's odd for a 4xx base :-)
>

My understanding of things (which could be totally wrong) is that the
DMA we care about on BG/P (namely the Torus and Collective networks)
is coherent at the L2.  Of course the change in question is talking
about L1_CACHE_BYTES, so my reading of this is that its a sleazy way
of getting aligned mallocs that make interactions with the tightly
coupled networks easier/more-efficient.  I'm open to alternative
suggestions.

      -eric

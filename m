Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0H0RvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:51:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab0H0RvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mebIqRECY/aJv1rTrM/CcXScvqGdugs+QrIjrnm6xWKxUd9Fv8LxXBM0pOk4xUVwXk
         C1ENgcdnvdKy7JvV6GvoiNfMHZhbyUyo2j08cpiRxXp8kYDCA+t2ZmXkGoq/+TzR3/VC
         /SciJy4ICIyYadJfhjncyGzNKL2CSJDb5e7VU=
MIME-Version: 1.0
In-Reply-To: <20100827174313.GA26872@shell>
References: <20100826200318.GA13636@shell>
	<20100827011436.GB3521@parisc-linux.org>
	<20100827174313.GA26872@shell>
Date: Fri, 27 Aug 2010 13:51:06 -0400
X-Google-Sender-Auth: mvItC_kvfJBAn93aTuEmkImTmZQ
Message-ID: <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com>
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
From: Bob Copeland <me@bobcopeland.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 1:43 PM, Valerie Aurora <vaurora@redhat.com> wrote:
> On Thu, Aug 26, 2010 at 07:14:36PM -0600, Matthew Wilcox wrote:
>> Hrm.  I think we can do this a bit more pithily.
>>
>>       /* Only one propagation flag should be set, and no others */
>>       if (hweight32(type) != 1 &&
>>           (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>>               return 0;
>>
>> Too clever?
>
> I was hoping someone would go find the best bitop for me, thanks. :)
> hweight32() is an awkward name but the comment makes it clear.  I'm
> happy with either.
>
> Thanks for the help,

Didn't read surrounding code, but is that supposed to be '||'?

Otherwise the case where only a single non-propagation flag is
set no longer returns 0...

-- 
Bob Copeland %% www.bobcopeland.com

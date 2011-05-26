Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1EZJaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:30:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39372 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1EZJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=POEPJeMSSHJJekZJ8U6HgMSxWGPe92TcTO24RKbKfJQhcX+vlC1HmVKwxggalWqrSN
         WorEn7YPdg7wRhhGzqK3TyvOnN5pOjOz16UsICfgvyPh4+vY8J7gXU28lIW0GoGgMzgS
         RxCSdkIQyvGrzqgArcE0FAwk4ygSJWJk++oaY=
MIME-Version: 1.0
In-Reply-To: <4DDCFA6F.2020801@canonical.com>
References: <20110519182702.GA3337@maxin>
	<4DDCFA6F.2020801@canonical.com>
Date: Thu, 26 May 2011 10:30:03 +0100
Message-ID: <BANLkTinaVB-Y3kVzU9vHYUJs5P7Ea_JhOg@mail.gmail.com>
Subject: Re: [PATCH] drivers: video: Remove useless checks
From: Maxin B John <maxin.john@gmail.com>
To: tim.gardner@canonical.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        airlied@redhat.com, lethal@linux-sh.org, james@albanarts.com,
        error27@gmail.com, randy.dunlap@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 25, 2011 at 1:47 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 05/19/2011 12:27 PM, Maxin B John wrote:
>>
>> Comparing unsigned less than zero will never be true.
>> Removing similar checks from 'fbmem.c' and 'fbcmap.c'.
>
> Looks right to me, though there are other places that suffer from the same
> issue. See fb_set_cmap() and its use of 'int start' and cmap->start.

Thank you very much for reviewing the patch. As per your suggestion, I
have checked
the scenario is fb_set_cmap() and the use of 'int start' and 'cmap->start'.

IMHO, that scenario doesn't fall under the comparison of unsigned int
< 0. That scenario
looks similar to the below given code to me:
/*---------------------------------*/
#include <stdio.h>

int
main ()
{
  unsigned int u_int = -1;
  int s_int = 0;
  s_int = u_int;
  if (s_int < 0)
    printf ("s_int is less than 0\n");
  return 0;
}
/*---------------------------------*/

Please let me know your comments.

Best Regards,
Maxin

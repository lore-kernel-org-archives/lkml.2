Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab1CXAcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:32:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36886 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab1CXAcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dWpcTPlspmOjfR5/NhScWJ/gNb5OAj4ywlNE3LEXdJZprlLoLM/obfw2sA/pqt5qAT
         +tJ0lVHtPp76eSk0YpAc677/22KyC03bIkNerCfCAvVaEmHoM5XG6Bwiww6pH1o7yzGf
         JH0pbqVcy2+szT+2NUWJ6Y5uQb7BXvRyIRfuY=
MIME-Version: 1.0
In-Reply-To: <10444.1300926012@redhat.com>
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org> <10444.1300926012@redhat.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 Mar 2011 20:31:42 -0400
X-Google-Sender-Auth: cALxY7jgZkCQbCUqoZdfp4lP7FQ
Message-ID: <AANLkTikUYp6YxryaBcpCrs3XwxkvHZZSk5x3S4yNcD4c@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: support SMP dynamic percpu_alloc
To: David Howells <dhowells@redhat.com>
Cc: graf.yang@analog.com, uclinux-dev@uclinux.org,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:20 PM, David Howells wrote:
> Mike Frysinger wrote:
>> The percpu code requires more functions to be implemented in the mm core
>> which nommu currently does not provide.  So add inline implementations
>> since these are largely meaningless on nommu systems.
>
> Under what conditions are these required?
>
> I've seen one percpu compilation bug that I've made a patch for (see
> attached), but none of these.  Is SMP required to trigger them?

yes, it only occurs in SMP builds.

i havent seen the build error you mention below, but i think that's
because in a past discussion we determined that NOMMU ports should be
setting VMALLOC_START to 0 and VMALLOC_END to -1.  is that no longer
the case ?

there are bunch more places where things would fail if
VMALLOC_{START,END} werent defined ...
-mike

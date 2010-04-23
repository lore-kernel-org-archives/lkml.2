Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0DWQfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:35:19 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:49677 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0DWQfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=huvWe/2BhdUPB805nBOFXGiCRiD6ee+cl9tVdTNITApUL/G91l0rSEuZbinOuJcten
         EbRGLYbTtJBNJ2fzjh8rp1BmgdbMsi4YKQxZFdIQBrbcVMK9G1Pzwk8sDeMNxB9eXjS1
         +SBq2EVrophxkSXMKIYeBZX0MHufv2urFAcbk=
MIME-Version: 1.0
Reply-To: jiahua@gmail.com
In-Reply-To: <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
	 <4BD06B31.9050306@redhat.com>
	 <53c81c97-b30f-4081-91a1-7cef1879c6fa@default>
	 <4BD07594.9080905@redhat.com> <4BD16D09.2030803@redhat.com>
	 <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
Date: Fri, 23 Apr 2010 09:35:14 -0700
Message-ID: <r2h63b77a231004230935hae38da68l2de84cb1a2084a6b@mail.gmail.com>
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
From: Jiahua <jiahua@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 6:47 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:

> If I understand correctly, SSDs work much more efficiently when
> writing 64KB blocks.  So much more efficiently in fact that waiting
> to collect 16 4KB pages (by first copying them to fill a 64KB buffer)
> will be faster than page-at-a-time DMA'ing them.  If so, the
> frontswap interface, backed by an asynchronous "buffering layer"
> which collects 16 pages before writing to the SSD, may work
> very nicely.  Again this is still just speculation... I was
> only pointing out that zero-copy DMA may not always be the best
> solution.

I guess you are talking about the write amplification issue of SSD. In
fact, most of the new generation drives already solved the problem
with log like structure. Even with the old drives, the size of the
writes depends on the the size of the erase block, which is not
necessary 64KB.

Jiahua

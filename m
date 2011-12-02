Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1LBOpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:45:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46255 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab1LBOpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:45:31 -0500
Message-ID: <1322837127.2762.11.camel@edumazet-laptop>
Subject: Re: mmap
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?S=E9bastien?= Paumier 
	<sebastien.paumier@univ-mlv.fr>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 02 Dec 2011 15:45:27 +0100
In-Reply-To: <4ED8C275.7020907@univ-mlv.fr>
References: <4ED8C275.7020907@univ-mlv.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 décembre 2011 à 13:20 +0100, Sébastien Paumier a écrit :
> Hi,
> I have a question about mmap's behavior when one tries to map a file asking for 
> a length greater than the actual file size. When I run the attached code on a 
> 100 bytes file, I have the following output:
> 
> (... file content followed by zeros...)
> n=4096
> write: Bad address
> 
> So, it seems that the actual memory area provided by mmap is one page large and 
> not the requested length of filesize+10000. I guess that 'write' writes less 
> than requested because it was interrupted by the SIGBUS signal. And my question is:
> 
> shouldn't mmap either complain about the requested length or provide an 
> accessible area of the requested length, instead of silently failing ?


Accessing non existing memory leads to SIGBUS signal, not a silent
failure. Its documented behavior.

man mmap

       SIGBUS Attempted access to a portion of the buffer that does not corre‐
              spond to the file (for example, beyond  the  end  of  the  file,
              including  the  case  where  another  process  has truncated the
              file).



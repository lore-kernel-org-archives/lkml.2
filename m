Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab0GPSnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:43:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27448 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab0GPSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:42:59 -0400
Message-ID: <4C40A766.6060309@kernel.org>
Date: Fri, 16 Jul 2010 11:39:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: build failure after merge of the final tree
References: <20100716171124.064cf319.sfr@canb.auug.org.au>
In-Reply-To: <20100716171124.064cf319.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C40A80B.00BD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 12:11 AM, Stephen Rothwell wrote:
> Hi Russell,
> 
> After merging the final tree, today's linux-next build (most, if not all
> arm configs) failed (not unexpectedly) due to the lmb -> memblock rename
> (commit 95f72d1ed41a66f1c1c29c24d479de81a0bea36f "lmb: rename to
> memblock").
> 
> See http://kisskb.ellerman.id.au/kisskb/branch/9/

You or Russell may need to run the scripts in that patch

      FILES=$(find * -type f | grep -vE 'oprofile|[^K]config')

      sed -i \
        -e 's/lmb/memblock/g' \
        -e 's/LMB/MEMBLOCK/g' \
        $FILES

      for N in $(find . -name lmb.[ch]); do
        M=$(echo $N | sed 's/lmb/memblock/g')
        mv $N $M
      done


Thanks

Yinghai

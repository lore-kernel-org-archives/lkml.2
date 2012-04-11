Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2DKHgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:36:09 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:39936 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab2DKHgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:36:07 -0400
Message-ID: <4F85337C.7080806@st.com>
Date: Wed, 11 Apr 2012 08:32:12 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20120411121058.088008039d669521e9afdfeb@canb.auug.org.au>
In-Reply-To: <20120411121058.088008039d669521e9afdfeb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no reason why __kfifo_max_r should not be exported to modules.
All the __kfifo_* functions in kfifo.h are already exported except this one.
Am happy to generate a patch.

On 11/04/12 03:10, Stephen Rothwell wrote:
> Hi Mauro,
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "__kfifo_max_r" [drivers/media/rc/rc-core.ko] undefined!
>
> Caused by commit 24a19bcbceda ("[media] ir-raw: Check available elements
> in kfifo before adding").  kfifo_avail expands to a call to __kfifo_max_r
> which is not exported to modules.
>
> I have used the v4l-dvb tree from next-20120410 for today.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0DXI4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 04:56:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34414 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0DXI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 04:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Vn1mW7xobdNlQ2AeF5/mjR05LQG+x/nXF/u63qsE3X1zcefm52DP58A/UVO6/HHXNl
         KMh5/Oom5hog6M6SMXVKgJpP9vdwaT2WVLEhPRXK9DSZo8YKwp4mBXQxCSZGZlgyDZyR
         dI1jF4CD2pKltAvg8VtEa8XUx/k7MleCln3bw=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: me@bobcopeland.com
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sat, 24 Apr 2010 09:56:45 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mickflemm@gmail.com
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423134823.GB5004@tuxdriver.com> <20100423163703.GB11112@hash.localnet>
In-Reply-To: <20100423163703.GB11112@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004240956.45899.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Sexta, 23 de Abril de 2010 17:37:03 me@bobcopeland.com escreveu:
> On Fri, Apr 23, 2010 at 09:48:23AM -0400, John W. Linville wrote:
> > > a) is it "normal"? I thought modules were somewhat isolated these days.
> > > b) any advices for debugging? I've yet to have two oopses that are
> > > similar....
> 
> Advice for debugging: turn on slub/slab debug options, and possibly
> kmemcheck.  kmemcheck was very helpful for me last time I had such
> a corruption issue.


For some reason I am unable to get a kernel I compiled to boot. Since I was 
unable to compile the kernel with those debugging options, I just turned on 
slub_debug on GRUB.

I got a few messages which I pasting here only partially to check for their 
significance. If significant I'll post them fully:

[ 2658.663308] 
=============================================================================
[ 2658.663424] BUG kmalloc-4096: Poison overwritten
[ 2658.663483] 
-----------------------------------------------------------------------------
[ 2658.663486] 
[ 2658.663606] INFO: 0xed3db0c0-0xed3db0cf. First byte 0xc4 instead of 0x6b
[ 2658.663698] INFO: Allocated in ath_rxbuf_alloc+0x30/0xa0 [ath] age=7117 
cpu=0 pid=0
[ 2658.663799] INFO: Freed in skb_release_data+0x70/0xa0 age=0 cpu=0 pid=0
[ 2658.663882] INFO: Slab 0xc15fbb00 objects=7 used=5 fp=0xed3db090 
flags=0x400040c3
[ 2658.663975] INFO: Object 0xed3db090 @offset=12432 fp=0xed3da060
[ 2658.663977] 
[ 2658.664069] Bytes b4 0xed3db080:  00 00 00 00 61 ff 08 00 5a 5a 5a 5a 5a 5a 
5a 5a ....a<FF>..ZZZZZZZZ
[ 2658.664258]   Object 0xed3db090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b kkkkkkkkkkkkkkkk

(a lot of lines with memory contents omitted)

[ 2658.667258]  Redzone 0xed3dc090:  bb bb bb bb                                     
<BB><BB><BB><BB>            
[ 2658.667258]  Padding 0xed3dc0b8:  5a 5a 5a 5a 5a 5a 5a 5a                         
ZZZZZZZZ        
[ 2658.667258] Pid: 0, comm: swapper Not tainted 2.6.32-21-generic #32-Ubuntu
[ 2658.667258] Call Trace:
[ 2658.667258]  [<c01faf63>] print_trailer+0xd3/0x120
[ 2658.667258]  [<c01fb07c>] check_bytes_and_report+0xcc/0xf0
[ 2658.667258]  [<c01fc021>] check_object+0x1a1/0x1e0
[ 2658.667258]  [<c01fcc98>] alloc_debug_processing+0xc8/0x190
(...)


[ 2658.667258] FIX kmalloc-4096: Restoring 0xed3db0c0-0xed3db0cf=0x6b
[ 2658.667258] 
[ 2658.667258] FIX kmalloc-4096: Marking all objects used
[ 4689.941595] 


And I've two or three more similar messages. The system was apparently stable 
in the morning though I had an error on the console:

[24370.460011] Pid: 2011, comm: kismet_server Not tainted 2.6.32-21-generic 
#32-Ubuntu
[24370.460011] Call Trace:
(...)


The latest daily from Ubuntu PPA wouldn't boot, the one from 2 or 3 days ago 
did, if needed I can install that one.


Were those lines significant and shall I post them here?


Thank you for your time,
-- 
Pedro

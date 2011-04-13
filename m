Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab1DMLcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:32:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57385 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab1DMLcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WANxgzl8zlaMkSyYhCngz7Wa6wPHfQ6QMCLnl8ba9hqPxk5KWJRtjQgk1wSh87aMGZ
         9GXOfBCxuggCqkE7/H4a09dlJFhIO5d10Twn4OxaKctwbu22E5DeZ6aKPn+qXNmZxhKV
         Gy5CQb82AX5KvgO/oKMlcT6862IG2BwFwo5v0=
Date: Wed, 13 Apr 2011 15:32:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Eugene Teo <eugene@redhat.com>, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Pekka Savola <pekkas@netcore.fi>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110413113204.GB6948@albatros>
References: <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 13:29 +0300, Alexey Dobriyan wrote:
> On Sat, Apr 9, 2011 at 1:15 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > This patch adds IPPROTO_ICMP socket kind.
> 
> > +       seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> > +               " %02X %08X:%08X %02X:%08lX %08X %5d %8d %lu %d %p %d%n",
> > +               bucket, src, srcp, dest, destp, sp->sk_state,
> > +               sk_wmem_alloc_get(sp),
> > +               sk_rmem_alloc_get(sp),
> > +               0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),
> 
> These zeroes can be embedded into format string for slightly faster printing.

Is it really needed?  I mean, it is not a fast path, so such a small
overhead is not very bad.  But embedding them into the string makes it a
bit more difficult to read.

> > +static const struct file_operations ping_seq_fops = {
> > +       .owner          = THIS_MODULE,
> 
> Unnecessary line.
> ->owner is unused for proc files, this is not documented anywhere, but
> it's unused.

OK.

> > +static const char ping_proc_name[] = "icmp";
> 
> Ewww :-)
> Does not compiler create only one string?

I used it for better readability as it is used 2 times.

> > +       p = proc_create_data(ping_proc_name, S_IRUGO, net->proc_net,
> > +                            &ping_seq_fops, NULL);
> 
> There is proc_net_fops_create().

OK.

> > +#ifdef CONFIG_IP_PING
> > +               table[7].data =
> > +                       &net->ipv4.sysctl_ping_group_range;
> > +#endif
> 
> Now I understand it's not related, but next sysctl will have
> "table[8].data = ..." line which is off-by-one if CONFIG_IP_PING=n.

Agreed that hardcoded indexes look a bit ugly, especially with
configurable elements.  But as Dave suggested to completely remove
CONFIG_IP_PING, it doesn't make sense now.

Thank you,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

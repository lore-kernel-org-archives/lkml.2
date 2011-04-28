Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab1D1PRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:17:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab1D1PQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G6dZ8TdG37gzbQpvTF25iDm+L4ZUQqlHEC7F/1Js3AX6aXL7Yqg/8uk+bJiX55+aa0
         WegKnpsnvhIDdzkT15ug==
MIME-Version: 1.0
In-Reply-To: <20110428073417.GA2220@redhat.com>
References: <1303965163-8198-1-git-send-email-decot@google.com>
 <1303965163-8198-3-git-send-email-decot@google.com> <20110428073417.GA2220@redhat.com>
From: David Decotigny <decot@google.com>
Date: Thu, 28 Apr 2011 08:16:34 -0700
Message-ID: <BANLkTiku9A3V0kbj+tcO8Sp4o_JZ=d2jzg@mail.gmail.com>
Subject: Re: [PATCHv4 2/7] ethtool: Call ethtool's get/set_settings callbacks
 with cleaned data
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, mirq-linux@rere.qmqm.pl,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanislaw, as Ben mentions, it's calling phy_ethtool_sset() which is
certainly meant to be an ETHTOOL_SSET op (from its name and comments)
even though its current implementation doesn't actually care for the
value of the cmd field.

Regards,

--
David Decotigny



On Thu, Apr 28, 2011 at 12:34 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Apr 27, 2011 at 09:32:38PM -0700, David Decotigny wrote:
>> --- a/drivers/net/stmmac/stmmac_ethtool.c
>> +++ b/drivers/net/stmmac/stmmac_ethtool.c
>> @@ -237,13 +237,12 @@ stmmac_set_pauseparam(struct net_device *netdev,
>>
>>       if (phy->autoneg) {
>>               if (netif_running(netdev)) {
>> -                     struct ethtool_cmd cmd;
>> +                     struct ethtool_cmd cmd = { .cmd = ETHTOOL_SSET };
>>                       /* auto-negotiation automatically restarted */
>> -                     cmd.cmd = ETHTOOL_NWAY_RST;
>
> Why did you change ETHTOOL_NWAY_RST to ETHTOOL_SSET ?
>
>

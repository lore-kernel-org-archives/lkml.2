Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0IDMh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:37:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34350 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0IDMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=qcmBUo+lt7pZE6y/NGGh67i9FOISaumQYTarmNl4VyK8wORdOJdJZKWV6lj35yB4U7
         kEipuD1HdZsCsS6t9gjKRAVrQYZS0ym8BMLP8ficPwhq/HUSiM/jJVTrjavE4wLM2nH2
         KPV8COwwJg2KYivjWxYTb9PbhiJcJgfiTRmts=
Message-ID: <4C823DA0.3050203@gmail.com>
Date: Sat, 04 Sep 2010 14:37:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: ML netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: sch_atm: null dereference
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found a potential null dereference:
atm_tc_change
  -> if (flow)
    -> return -EBUSY;
  -> flow is NULL now
  -> if (classid)
    -> if (!list_empty(&flow->list))

Introduced probably in
    sch_atm: Convert to use standard list_head facilities.

Could you fix that?

regards,
-- 
js

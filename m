Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0IDM77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:59:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48273 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0IDM75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=OW3ExJNfhW9/pmzzMgA9xlmVaY1EJRJ4KTq1yB2IA27lxBkxZVyGszbJeDgxCZhY2y
         Iwm5KTG06zq6j3uwprWMyeCFyC1t81PC3Nb2e5JHJ4AqFbDcl9QcvdU/BNvyyS3dhWwb
         jWGDLixV7fGadEXoG6T88qkGJMGswzCo9FwYQ=
Message-ID: <4C8242CA.3020906@gmail.com>
Date: Sat, 04 Sep 2010 14:59:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: ddutt@brocade.com
CC: rmody@brocade.com, "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: bna: potential null dereference
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found a potential null dereference:
bnad_cb_tx_cleanup
  -> struct bnad_unmap_q *unmap_q = tcb->unmap_q;
  -> -- tcb cannot be null now --
  -> if (!tcb || (!tcb->unmap_q))

The thing is I have no idea whether the second parameter of cleanup may
be null (move assignment after the check) or not (remove the check)

Could you fix that?

thanks,
-- 
js

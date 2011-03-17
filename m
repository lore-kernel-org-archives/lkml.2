Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1CQOYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:24:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57866 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1CQOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=G8OhloCuuV+sEti2ZuY4c43MK9aXiogAuuVsgHTcwtZHFRxkkkxOc1/ktPp+1jM+jN
         f4P1fxYinVcBWZaZAFKZfsN7vkeID+4VCPNEHAcnW3owWIvQC2BJubhHV3uwWlOollfI
         w6uN/PAeeCJ469ljQ8zwNgxVdEOeZk45/e308=
Subject: Poll about irqsafe_cpu_add and others
From: Eric Dumazet <eric.dumazet@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 15:23:54 +0100
Message-ID: <1300371834.6315.93.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

irqsafe_cpu_{dec|inc} are used in network stack since 2.6.37 (commit
29b4433d991c88), and I would like to use irqsafe_cpu_add() in netfilter
fast path too, and SNMP counters eventually (to lower ram needs by 50%)

Initial support of irqsafe_ was given by Christoph in 2.6.34

It seems only x86 arch is using a native and efficient implementation.

Others use irqsafe_cpu_generic_to_op() and its pair of
local_irq_save() / local_irq_restore()

Which other arches could use a native implementation ?

What about defining a HAVE_FAST_IRQSAFE_ADD ?

Thanks



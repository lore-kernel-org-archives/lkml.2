Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0ILBMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 21:12:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63439 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0ILBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 21:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=nihbixxst+QOBi5ra3LWA4C2LnxEy0ARArFj7swZG29GTZF20Enz/PeRMrLfoRh4bx
         XSDUc6XJ6Axr4Awzz9GRq4TjRqMKAz7LQ1B/SXbeMZ08Tlnd2J4m0S9w2929G6umYYTD
         9J9+MT2kafIge68p1do48zHl8fMyTCEIvTBNw=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 21:12:27 -0400
X-Google-Sender-Auth: toEHbRAws05Juh6F7z2mZYfrwYQ
Message-ID: <AANLkTi=3me5AsWLVpy7Xku_Qr2ajxJzHULnhWgSz14k=@mail.gmail.com>
Subject: [PATCHv2 0/5] sctp: add multistream scheduling feature
From: Yaogong Wang <ywang15@ncsu.edu>
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCTP supports multistreaming. It solves the head-of-line blocking
problem of TCP and makes SCTP a proper transport for signaling.
However, this feature can be further exploited to provide QoS
scheduling among multiple streams. This is what we want to add in this
patch.

In the current implementation, multiple streams in an SCTP association
are scheduled in a first-come-first-serve (FCFS) fashion. We would
like to augment this simple algorithm with many other scheduling
algorithms and let the application choose which scheduling algorithm
they want to use. We provide a multistream scheduling framework in the
kernel so that different scheduling algorithms can be implemented as
kernel modules. We also extend the SCTP socket API to include a new
socket option for applications to choose and configure the scheduling
algorithm. This approach is inspired by the pluggable TCP congestion
control mechanism in the Linux kernel.

Note that this modification doesn't change the protocol on the wire.
It only changes the internal scheduling. Therefore, it won't cause any
interoperability problem. Further, this modification doesn't change
the congestion control algorithm of SCTP. It only changes which data
chunk should be transmitted first, under the constraints of the
congestion window. Therefore, it's safe to be deployed in the
Internet.

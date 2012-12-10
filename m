Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2LJKIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:08:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35089 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2LJKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:08:20 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH] Introduce rproc serial device specification.
Date: Mon, 10 Dec 2012 11:08:09 +0100
Message-Id: <1355134089-3284-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121210055443.GB17187@amit.redhat.com>
References: <20121210055443.GB17187@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---

>> Please pick the virtio spec from
>> 
>> https://github.com/rustyrussell/virtio-spec
>> 
>> and update the spec with info for remote-proc.
>
>Hi Sjur,
>
>I didn't hear back from you on this..
>

Hi Amit
Sorry for the delay. I've had this ready for a while waiting for
go-ahead from our legal dept, and then it got stuck in my backlog.

Anyway, here is a stab at describing the rproc serial device.
Feedback is welcomed.

Thanks,
Sjur


 virtio-spec.lyx |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index 83f2771..bbb5c75 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -9079,6 +9079,64 @@ For MMC devices (inquiry type 5) there would be some overlap between this
 
 \end_deeper
 \begin_layout Chapter*
+Appendix J: Rproc Serial Device
+\end_layout
+
+\begin_layout Standard
+The Remoteproc Serial Device device is used when communicating with a remote
+ processor.
+ The remote processor may be a modem communicating over a shared memory
+ interface, or a CPU in an asymmetric multi-processing (AMP) configuration.
+ The Remoteproc Serial Device provides a simple device for data IO.
+ A device has one port and a single pair of virtqueues for input and output.
+ Empty buffers are placed in one virtqueue for receiving packets, and outgoing
+ packets are enqueued into another for transmission.
+\end_layout
+
+\begin_layout Section*
+Configuration
+\end_layout
+
+\begin_layout Description
+Subsystem
+\begin_inset space ~
+\end_inset
+
+Device
+\begin_inset space ~
+\end_inset
+
+ID 11
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+Virtqueues 0:receiveq(port0).
+ 1:transmitq(port0),
+\end_layout
+
+\begin_layout Section*
+Device Initialization
+\end_layout
+
+\begin_layout Enumerate
+The receiveq for each port is populated with one or more receive buffers.
+\end_layout
+
+\begin_layout Section*
+Device Operation
+\end_layout
+
+\begin_layout Enumerate
+For output, a buffer containing the characters is placed in the port's transmitq.
+\end_layout
+
+\begin_layout Enumerate
+Inbound messages are placed in the receiveq and signalled by an interrupt.
+\end_layout
+
+\end_deeper
+\begin_layout Chapter*
 Appendix X: virtio-mmio
 \end_layout
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1DJDuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 23:50:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1DJDum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 23:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BWfbwnFPoQH/5HZvXdHCtm7qIpeO+Qhx7x/n8EEcCeFrXf/OImUNZyD3f8tG73Bm/u
         Q2PcPYok0tAB6tuyeDKa5cl/skJfYQvN+28PxJNkoZb7DY928cHzoXoe9fg9SeeH4/eY
         QwRlGIrCa8A1KmKWJHZ8RG1utVtAzWXjCOXA8=
Message-ID: <4DA12905.2020806@gmail.com>
Date: Sat, 09 Apr 2011 21:50:29 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: adding trace-cmd's plugins to perf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now perf script cannot process kvm tracepoints:

perf record -e kvm:* -p 6446 -- sleep 5

perf script
  Warning: Error: expected type 4 but read 7
  Warning: Error: expected type 5 but read 0
  Warning: failed to read event print fmt for kvm_apic
  Warning: Error: expected type 4 but read 7
  Warning: Error: expected type 5 but read 0
  Warning: failed to read event print fmt for kvm_inj_exception
  Fatal: bad op token {

trace-cmd can parse the events through the kvm plugin.

As I understand it trace-cmd and perf have a lot of similar code, so I
would expect to be able to add the plugin capability to perf somewhat
easily. However, that does not seem to be the right thing to do (copying
yet more code between the two).

Before I invest a lot of time on this path I figured I should ask what
the intentions (roadmap seems to be too formal a word ;-)) are about
merging common code between the two commands. Also, trace-cmd and perf
are in separate repositories so a shared lib is going to inconvenience
one of the two.

Thanks,
David

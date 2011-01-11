Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1AKE1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:27:50 -0500
Received: from mx2.parallels.com ([64.131.90.16]:55219 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab1AKE1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:27:42 -0500
Message-ID: <4D2BDC29.3030408@parallels.com>
Date: Mon, 10 Jan 2011 22:27:21 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] update Thunderbird docs with wordwrap plugin.
References: <4D2579B2.7060704@parallels.com>	<20110106154120.b69118c9.akpm@linux-foundation.org>	<4D2AC4D5.5070503@parallels.com> <20110110091509.f7d338eb.randy.dunlap@oracle.com>
In-Reply-To: <20110110091509.f7d338eb.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 11:15 AM, Randy Dunlap wrote:
> On Mon, 10 Jan 2011 02:35:33 -0600 Rob Landley wrote:
> 
>> On 01/06/2011 05:41 PM, Andrew Morton wrote:
>>> Probably a worthwhile thing to do, IMO.  If there's some 
>>> net-specific CONFIG_DEBUG_ setting then that wold be a better 
>>> thing to use.
>>> 
>>> However the patch was a) wordwrapped, b) space-stuffed and c)
>>> not cc'ed to the networking list.  So its prospects are dim.
>> 
>> Ok, either I've beaten thunderbird into submission, or I'll be 
>> submitting a patch to Documentation/email-clients.txt.  (Whether
>> or not I need to find a different smtp server to send this through
>>  remains an open question.)
> 
> 
> Hi Rob, The patch applies cleanly.

Yay!

> However, if you have any additions/updates to 
> Documentation/email-clients.txt, please send them along.
> 
> and please do hard CR/LF every 70-72 characters or so, instead of 
> very_long_lines.

[Long rant about baked-in stupidity in Thunderbird mercifully deleted.]

I dug up a wordwrap extension and installed it, giving me an "options->enable
wordwrap" control.  I had to undo one of the steps in email-clients.txt to
get it to work, and rewrote email-clients.txt accordingly:

From: Rob Landley <rlandley@parallels.com>

Show how to install the "toggle wordwrap" extension in thunderbird.

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 Documentation/email-clients.txt |   43 ++++++++++++++++--------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 945ff3f..714b8ca 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -179,26 +179,8 @@ Sylpheed (GUI)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Thunderbird (GUI)
 
-By default, thunderbird likes to mangle text, but there are ways to
-coerce it into being nice.
-
-- Under account settings, composition and addressing, uncheck "Compose
-  messages in HTML format".
-
-- Edit your Thunderbird config settings to tell it not to wrap lines:
-      user_pref("mailnews.wraplength", 0);
-
-- Edit your Thunderbird config settings so that it won't use format=flowed:
-      user_pref("mailnews.send_plaintext_flowed", false);
-
-- You need to get Thunderbird into preformat mode:
-. If you compose HTML messages by default, it's not too hard. Just select
-  "Preformat" from the drop-down box just under the subject line.
-. If you compose in text by default, you have to tell it to compose a new
-  message in HTML (just as a one-off), and then force it from there back to
-  text, else it will wrap lines. To do this, use shift-click on the Write
-  icon to compose to get HTML compose mode, then select "Preformat" from
-  the drop-down box just under the subject line.
+Thunderbird is an Outlook clone that likes to mangle text, but there are ways
+to coerce it into behaving.
 
 - Allows use of an external editor:
   The easiest thing to do with Thunderbird and patches is to use an
@@ -208,6 +190,27 @@ coerce it into being nice.
   View->Toolbars->Customize... and finally just click on it when in the
   Compose dialog.
 
+To beat some sense out of the internal editor, do this:
+
+- Under account settings, composition and addressing, uncheck "Compose
+  messages in HTML format".
+
+- Edit your Thunderbird config settings so that it won't use format=flowed.
+  Go to "edit->preferences->advanced->config editor" to bring up the
+  thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
+  "false".
+
+- Enable "preformat" mode: Shft-click on the Write icon to bring up the HTML
+  composer, select "Preformat" from the drop-down box just under the subject
+  line, then close the message without saving.  (This setting also applies to
+  the text composer, but the only control for it is in the HTML composer.)
+
+- Install the "toggle wordwrap" extension.  Download the file from:
+    https://addons.mozilla.org/thunderbird/addon/2351/
+  Then go to "tools->add ons", select "install" at the bottom of the screen,
+  and browse to where you saved the .xul file.  This adds an "Enable
+  Wordwrap" entry under the Options menu of the message composer.
+
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 TkRat (GUI)
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0DUAuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:50:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:42583 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0DUAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=K0NpKdVynr+QBSLe2JX8Af/KQUYf2AN6HPm+PzhPGa14yzIEVf7t2nfyuYZVCqPrtb
         5zxulivUpPveI5sbafuHum+0IQq1SiUqxaHYhuHSaA3t2FDV6SNst9wYdF/w1zoiKJyQ
         FS5srI7tbXwRstiI5sfTP0g2RzWBlhXipjHts=
Subject: [PATCH] Staging: batman-adv: fix checkpath.pl issues
From: Mikal Sande <mikal.sande@gmail.com>
To: andrew@lunn.ch, lindner_marek@yahoo.de, gregkh@suse.de,
       siwu@hrz.tu-chemnitz.de, sdietrich@novell.com, sven.eckelmann@gmx.de,
       linus.luessing@web.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 21 Apr 2010 02:49:38 +0200
Message-Id: <1271810978.14405.14.camel@pondus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fc01d526b79f61248191493c7ac779def6b50281 Mon Sep 17 00:00:00 2001
From: Mikal Sande <mikal.sande@gmail.com>
Date: Wed, 21 Apr 2010 00:18:14 +0200
Subject: [PATCH] Staging: batman-adv: fix checkpath.pl issues
 This is a patch to all the .c files in batman-adv that fixes the checkpatch.pl issues
 Signed-off-by: Mikal Sande <mikal.sande@gmail.com>

---
 drivers/staging/batman-adv/device.c            |   16 ++++--
 drivers/staging/batman-adv/hard-interface.c    |   13 +++-
 drivers/staging/batman-adv/main.c              |   13 +++-
 drivers/staging/batman-adv/originator.c        |   10 ++-
 drivers/staging/batman-adv/proc.c              |   73 ++++++++++++++++-------
 drivers/staging/batman-adv/routing.c           |   44 ++++++++++----
 drivers/staging/batman-adv/send.c              |   26 +++++---
 drivers/staging/batman-adv/translation-table.c |   21 ++++---
 drivers/staging/batman-adv/vis.c               |   10 ++-
 9 files changed, 154 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/batman-adv/device.c b/drivers/staging/batman-adv/device.c
index 2f61500..8a5de9f 100644
--- a/drivers/staging/batman-adv/device.c
+++ b/drivers/staging/batman-adv/device.c
@@ -68,7 +68,7 @@ int bat_device_setup(void)
 	batman_class = class_create(THIS_MODULE, "batman-adv");
 
 	if (IS_ERR(batman_class)) {
-		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv' \n");
+		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv'\n");
 		return 0;
 	}
 
@@ -111,7 +111,7 @@ int bat_device_open(struct inode *inode, struct file *file)
 	}
 
 	if (device_client_hash[i] != device_client) {
-		printk(KERN_ERR "batman-adv:Error - can't add another packet client: maximum number of clients reached \n");
+		printk(KERN_ERR "batman-adv: Error - can't add another packet client: maximum number of clients reached\n");
 		kfree(device_client);
 		return -EXFULL;
 	}
@@ -212,7 +212,9 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 	unsigned long flags;
 
 	if (len < sizeof(struct icmp_packet)) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: invalid packet size\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:" +
+			"Error - can't send packet from char device: " +
+			"invalid packet size\n");
 		return -EINVAL;
 	}
 
@@ -223,12 +225,16 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 		return -EFAULT;
 
 	if (icmp_packet.packet_type != BAT_ICMP) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: got bogus packet type (expected: BAT_ICMP)\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:" +
+			"Error - can't send packet from char device: " +
+			"got bogus packet type (expected: BAT_ICMP)\n");
 		return -EINVAL;
 	}
 
 	if (icmp_packet.msg_type != ECHO_REQUEST) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: got bogus message type (expected: ECHO_REQUEST)\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:" +
+			"Error - can't send packet from char device: "+
+			"got bogus message type (expected: ECHO_REQUEST)\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index befd488..7c9b7e0 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -117,7 +117,8 @@ static int hardif_is_interface_up(char *dev)
 	if ((!list_empty(&if_list)) &&
 	    strncmp(((struct batman_if *)if_list.next)->dev, dev, IFNAMSIZ) &&
 	    !(((struct batman_if *)if_list.next)->if_active == IF_ACTIVE) &&
-	    !(((struct batman_if *)if_list.next)->if_active == IF_TO_BE_ACTIVATED) &&
+	    !(((struct batman_if *)if_list.next)->if_active ==
+	    IF_TO_BE_ACTIVATED) &&
 	    (!main_if_was_up())) {
 		rcu_read_unlock();
 		goto end;
@@ -280,7 +281,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if = kmalloc(sizeof(struct batman_if), GFP_KERNEL);
 
 	if (!batman_if) {
-		printk(KERN_ERR "batman-adv:Can't add interface (%s): out of memory\n", dev);
+		printk(KERN_ERR "batman-adv:Can't add interface (%s): "
+			"out of memory\n", dev);
 		return -1;
 	}
 
@@ -294,7 +296,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->packet_buff = kmalloc(batman_if->packet_len, GFP_KERNEL);
 
 	if (!batman_if->packet_buff) {
-		printk(KERN_ERR "batman-adv:Can't add interface packet (%s): out of memory\n", dev);
+		printk(KERN_ERR "batman-adv:Can't add interface packet (%s): "
+			"out of memory\n", dev);
 		goto out;
 	}
 
@@ -344,7 +347,9 @@ int hardif_add_interface(char *dev, int if_num)
 	spin_unlock_irqrestore(&orig_hash_lock, flags);
 
 	if (!hardif_is_interface_up(batman_if->dev))
-		printk(KERN_ERR "batman-adv:Not using interface %s (retrying later): interface not active\n", batman_if->dev);
+		printk(KERN_ERR "batman-adv:Not using interface %s "
+			"(retrying later): interface not active\n",
+			batman_if->dev);
 	else
 		hardif_activate_interface(batman_if);
 
diff --git a/drivers/staging/batman-adv/main.c b/drivers/staging/batman-adv/main.c
index 2e0b482..27f12d0 100644
--- a/drivers/staging/batman-adv/main.c
+++ b/drivers/staging/batman-adv/main.c
@@ -105,22 +105,27 @@ int init_module(void)
 				   interface_setup);
 
 	if (!soft_device) {
-		printk(KERN_ERR "batman-adv:Unable to allocate the batman interface\n");
+		printk(KERN_ERR "batman-adv:"
+			"Unable to allocate the batman interface\n");
 		goto end;
 	}
 
 	retval = register_netdev(soft_device);
 
 	if (retval < 0) {
-		printk(KERN_ERR "batman-adv:Unable to register the batman interface: %i\n", retval);
+		printk(KERN_ERR "batman-adv:"
+			"Unable to register the batman interface: %i\n",
+				retval);
 		goto free_soft_device;
 	}
 
 	register_netdevice_notifier(&hard_if_notifier);
 	dev_add_pack(&batman_adv_packet_type);
 
-	printk(KERN_INFO "batman-adv:B.A.T.M.A.N. advanced %s%s (compatibility version %i) loaded \n",
-		  SOURCE_VERSION, REVISION_VERSION_STR, COMPAT_VERSION);
+	printk(KERN_INFO "batman-adv:"
+		"B.A.T.M.A.N. advanced %s%s (compatibility version %i) "
+			"loaded\n", SOURCE_VERSION, REVISION_VERSION_STR,
+				COMPAT_VERSION);
 
 	return 0;
 
diff --git a/drivers/staging/batman-adv/originator.c b/drivers/staging/batman-adv/originator.c
index 29c2411..8131dd0 100644
--- a/drivers/staging/batman-adv/originator.c
+++ b/drivers/staging/batman-adv/originator.c
@@ -126,7 +126,7 @@ struct orig_node *get_orig_node(uint8_t *addr)
 	if (orig_node != NULL)
 		return orig_node;
 
-	bat_dbg(DBG_BATMAN, "Creating new originator: %pM \n", addr);
+	bat_dbg(DBG_BATMAN, "Creating new originator: %pM\n", addr);
 
 	orig_node = kzalloc(sizeof(struct orig_node), GFP_ATOMIC);
 	if (!orig_node)
@@ -158,7 +158,7 @@ struct orig_node *get_orig_node(uint8_t *addr)
 
 		if (swaphash == NULL)
 			printk(KERN_ERR
-			       "batman-adv:Couldn't resize orig hash table \n");
+			       "batman-adv:Couldn't resize orig hash table\n");
 		else
 			orig_hash = swaphash;
 	}
@@ -191,7 +191,11 @@ static bool purge_orig_neighbors(struct orig_node *orig_node,
 			       (neigh_node->last_valid +
 				((PURGE_TIMEOUT * HZ) / 1000)))) {
 
-			bat_dbg(DBG_BATMAN, "neighbor timeout: originator %pM, neighbor: %pM, last_valid %lu\n", orig_node->orig, neigh_node->addr, (neigh_node->last_valid / HZ));
+			bat_dbg(DBG_BATMAN, "neighbor timeout: "
+				"originator %pM, neighbor: %pM, last_valid "
+								"%lu\n",
+					orig_node->orig, neigh_node->addr,
+					(neigh_node->last_valid / HZ));
 
 			neigh_purged = true;
 			list_del(list_pos);
diff --git a/drivers/staging/batman-adv/proc.c b/drivers/staging/batman-adv/proc.c
index 7de60e8..2a33efe 100644
--- a/drivers/staging/batman-adv/proc.c
+++ b/drivers/staging/batman-adv/proc.c
@@ -41,7 +41,7 @@ static int proc_interfaces_read(struct seq_file *seq, void *offset)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(batman_if, &if_list, list) {
-		seq_printf(seq, "[%8s] %s %s \n",
+		seq_printf(seq, "[%8s] %s %s\n",
 			   (batman_if->if_active == IF_ACTIVE ?
 			    "active" : "inactive"),
 			   batman_if->dev,
@@ -99,7 +99,9 @@ static ssize_t proc_interfaces_write(struct file *instance,
 	rcu_read_lock();
 	list_for_each_entry_rcu(batman_if, &if_list, list) {
 		if (strncmp(batman_if->dev, if_string, count) == 0) {
-			printk(KERN_ERR "batman-adv:Given interface is already active: %s\n", if_string);
+			printk(KERN_ERR "batman-adv:"
+				"Given interface is already active: %s\n",
+								if_string);
 			rcu_read_unlock();
 			goto end;
 
@@ -188,18 +190,21 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - "
+				"please specify interfaces to enable it\n");
 		goto end;
 	}
 
 	if (((struct batman_if *)if_list.next)->if_active != IF_ACTIVE) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - primary interface not active \n");
+		seq_printf(seq, "BATMAN disabled - "
+				"primary interface not active\n");
 		goto end;
 	}
 
 	seq_printf(seq,
-		   "  %-14s (%s/%i) %17s [%10s]: %20s ... [B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s] \n",
+		   "  %-14s (%s/%i) %17s [%10s]: %20s ... "
+		   "[B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s]\n",
 		   "Originator", "#", TQ_MAX_VALUE, "Nexthop", "outgoingIF",
 		   "Potential nexthops", SOURCE_VERSION, REVISION_VERSION_STR,
 		   ((struct batman_if *)if_list.next)->dev,
@@ -240,7 +245,7 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	spin_unlock_irqrestore(&orig_hash_lock, flags);
 
 	if (batman_count == 0)
-		seq_printf(seq, "No batman nodes in range ... \n");
+		seq_printf(seq, "No batman nodes in range ...\n");
 
 end:
 	return 0;
@@ -262,13 +267,15 @@ static int proc_transt_local_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - "
+				"please specify interfaces to enable it\n");
 		goto end;
 	}
 
 	rcu_read_unlock();
 
-	seq_printf(seq, "Locally retrieved addresses (from %s) announced via HNA:\n", soft_device->name);
+	seq_printf(seq, "Locally retrieved addresses (from %s) "
+			"announced via HNA:\n", soft_device->name);
 
 	hna_local_fill_buffer_text(buf, 4096);
 	seq_printf(seq, "%s", buf);
@@ -294,13 +301,15 @@ static int proc_transt_global_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - "
+				"please specify interfaces to enable it\n");
 		goto end;
 	}
 	rcu_read_unlock();
 
 
-	seq_printf(seq, "Globally announced HNAs received via the mesh (translation table):\n");
+	seq_printf(seq, "Globally announced HNAs received via the mesh "
+						"(translation table):\n");
 
 	hna_global_fill_buffer_text(buf, 4096);
 	seq_printf(seq, "%s", buf);
@@ -350,9 +359,9 @@ static int proc_vis_srv_read(struct seq_file *seq, void *offset)
 {
 	int vis_server = atomic_read(&vis_mode);
 
-	seq_printf(seq, "[%c] client mode (server disabled) \n",
+	seq_printf(seq, "[%c] client mode (server disabled)\n",
 			(vis_server == VIS_TYPE_CLIENT_UPDATE) ? 'x' : ' ');
-	seq_printf(seq, "[%c] server mode (server enabled) \n",
+	seq_printf(seq, "[%c] server mode (server enabled)\n",
 			(vis_server == VIS_TYPE_SERVER_SYNC) ? 'x' : ' ');
 
 	return 0;
@@ -436,7 +445,9 @@ static ssize_t proc_aggr_write(struct file *file, const char __user *buffer,
 	retval = strict_strtoul(aggr_string, 10, &aggregation_enabled_tmp);
 
 	if (retval || aggregation_enabled_tmp > 1) {
-		printk(KERN_ERR "batman-adv:Aggregation can only be enabled (1) or disabled (0), given value: %li\n", aggregation_enabled_tmp);
+		printk(KERN_ERR "batman-adv:Aggregation can only be enabled"
+				" (1) or disabled (0), given value: %li\n",
+						aggregation_enabled_tmp);
 	} else {
 		printk(KERN_INFO "batman-adv:Changing aggregation from: %s (%i) to: %s (%li)\n",
 		       (atomic_read(&aggregation_enabled) == 1 ?
@@ -579,7 +590,9 @@ int setup_procfs(void)
 #endif
 
 	if (!proc_batman_dir) {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s' folder failed\n", PROC_ROOT_DIR);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s' folder failed\n",
+							PROC_ROOT_DIR);
 		return -EFAULT;
 	}
 
@@ -589,7 +602,9 @@ int setup_procfs(void)
 	if (proc_interface_file) {
 		proc_interface_file->proc_fops = &proc_interfaces_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_INTERFACES);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+					PROC_ROOT_DIR, PROC_FILE_INTERFACES);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -600,7 +615,9 @@ int setup_procfs(void)
 	if (proc_orig_interval_file) {
 		proc_orig_interval_file->proc_fops = &proc_orig_interval_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_ORIG_INTERVAL);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+				PROC_ROOT_DIR, PROC_FILE_ORIG_INTERVAL);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -610,7 +627,9 @@ int setup_procfs(void)
 	if (proc_originators_file) {
 		proc_originators_file->proc_fops = &proc_originators_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_ORIGINATORS);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+				PROC_ROOT_DIR, PROC_FILE_ORIGINATORS);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -620,7 +639,9 @@ int setup_procfs(void)
 	if (proc_transt_local_file) {
 		proc_transt_local_file->proc_fops = &proc_transt_local_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_TRANST_LOCAL);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+				PROC_ROOT_DIR, PROC_FILE_TRANST_LOCAL);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -630,7 +651,9 @@ int setup_procfs(void)
 	if (proc_transt_global_file) {
 		proc_transt_global_file->proc_fops = &proc_transt_global_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_TRANST_GLOBAL);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+				PROC_ROOT_DIR, PROC_FILE_TRANST_GLOBAL);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -641,7 +664,9 @@ int setup_procfs(void)
 	if (proc_vis_srv_file) {
 		proc_vis_srv_file->proc_fops = &proc_vis_srv_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_VIS_SRV);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+					PROC_ROOT_DIR, PROC_FILE_VIS_SRV);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -651,7 +676,9 @@ int setup_procfs(void)
 	if (proc_vis_data_file) {
 		proc_vis_data_file->proc_fops = &proc_vis_data_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_VIS_DATA);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+					PROC_ROOT_DIR, PROC_FILE_VIS_DATA);
 		cleanup_procfs();
 		return -EFAULT;
 	}
@@ -661,7 +688,9 @@ int setup_procfs(void)
 	if (proc_aggr_file) {
 		proc_aggr_file->proc_fops = &proc_aggr_fops;
 	} else {
-		printk(KERN_ERR "batman-adv: Registering the '/proc/net/%s/%s' file failed\n", PROC_ROOT_DIR, PROC_FILE_AGGR);
+		printk(KERN_ERR "batman-adv: "
+			"Registering the '/proc/net/%s/%s' file failed\n",
+					PROC_ROOT_DIR, PROC_FILE_AGGR);
 		cleanup_procfs();
 		return -EFAULT;
 	}
diff --git a/drivers/staging/batman-adv/routing.c b/drivers/staging/batman-adv/routing.c
index d89048b..89e2036 100644
--- a/drivers/staging/batman-adv/routing.c
+++ b/drivers/staging/batman-adv/routing.c
@@ -94,7 +94,10 @@ static void update_route(struct orig_node *orig_node,
 
 		/* route changed */
 	} else {
-		bat_dbg(DBG_ROUTES, "Changing route towards: %pM (now via %pM - was via %pM)\n", orig_node->orig, neigh_node->addr, orig_node->router->addr);
+		bat_dbg(DBG_ROUTES, "Changing route towards: "
+			"%pM (now via %pM - was via %pM)\n",
+				orig_node->orig, neigh_node->addr,
+					orig_node->router->addr);
 	}
 
 	if (neigh_node != NULL)
@@ -212,7 +215,9 @@ static int isBidirectionalNeigh(struct orig_node *orig_node,
 			      orig_neigh_node->tq_asym_penalty) /
 			     (TQ_MAX_VALUE *	 TQ_MAX_VALUE));
 
-	bat_dbg(DBG_BATMAN, "bidirectional: orig = %-15pM neigh = %-15pM => own_bcast = %2i, real recv = %2i, local tq: %3i, asym_penalty: %3i, total tq: %3i \n",
+	bat_dbg(DBG_BATMAN, "bidirectional: orig = %-15pM neigh = %-15pM => "
+		"own_bcast = %2i, real recv = %2i, local tq: %3i, "
+			"asym_penalty: %3i, total tq: %3i\n",
 		orig_node->orig, orig_neigh_node->orig, total_count,
 		neigh_node->real_packet_count, orig_neigh_node->tq_own,
 		orig_neigh_node->tq_asym_penalty, batman_packet->tq);
@@ -234,7 +239,8 @@ static void update_orig(struct orig_node *orig_node, struct ethhdr *ethhdr,
 	struct neigh_node *neigh_node = NULL, *tmp_neigh_node = NULL;
 	int tmp_hna_buff_len;
 
-	bat_dbg(DBG_BATMAN, "update_originator(): Searching and updating originator entry of received packet \n");
+	bat_dbg(DBG_BATMAN, "update_originator(): "
+		"Searching and updating originator entry of received packet\n");
 
 	list_for_each_entry(tmp_neigh_node, &orig_node->neigh_list, list) {
 		if (compare_orig(tmp_neigh_node->addr, ethhdr->h_source) &&
@@ -341,7 +347,7 @@ static char count_real_packets(struct ethhdr *ethhdr,
 	}
 
 	if (!is_duplicate) {
-		bat_dbg(DBG_BATMAN, "updating last_seqno: old %d, new %d \n",
+		bat_dbg(DBG_BATMAN, "updating last_seqno: old %d, new %d\n",
 			orig_node->last_real_seqno, batman_packet->seqno);
 		orig_node->last_real_seqno = batman_packet->seqno;
 	}
@@ -385,7 +391,9 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 	is_single_hop_neigh = (compare_orig(ethhdr->h_source,
 					    batman_packet->orig) ? 1 : 0);
 
-	bat_dbg(DBG_BATMAN, "Received BATMAN packet via NB: %pM, IF: %s [%s] (from OG: %pM, via prev OG: %pM, seqno %d, tq %d, TTL %d, V %d, IDF %d) \n",
+	bat_dbg(DBG_BATMAN, "Received BATMAN packet via NB: %pM, IF: %s [%s] "
+				"(from OG: %pM, via prev OG: "
+				"%pM, seqno %d, tq %d, TTL %d, V %d, IDF %d)\n",
 		ethhdr->h_source, if_incoming->dev, if_incoming->addr_str,
 		batman_packet->orig, batman_packet->prev_sender,
 		batman_packet->seqno, batman_packet->tq, batman_packet->ttl,
@@ -420,13 +428,16 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 
 	if (is_my_addr) {
 		bat_dbg(DBG_BATMAN,
-			"Drop packet: received my own broadcast (sender: %pM)\n",
-			ethhdr->h_source);
+			"Drop packet: "
+				"received my own broadcast (sender: %pM)\n",
+					ethhdr->h_source);
 		return;
 	}
 
 	if (is_broadcast) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all packets with broadcast source addr (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: "
+			"ignoring all packets with broadcast source addr "
+				"(sender: %pM)\n", ethhdr->h_source);
 		return;
 	}
 
@@ -454,19 +465,23 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 				bit_packet_count(word);
 		}
 
-		bat_dbg(DBG_BATMAN, "Drop packet: originator packet from myself (via neighbor) \n");
+		bat_dbg(DBG_BATMAN, "Drop packet: "
+			"originator packet from myself (via neighbor)\n");
 		return;
 	}
 
 	if (batman_packet->tq == 0) {
 		count_real_packets(ethhdr, batman_packet, if_incoming);
 
-		bat_dbg(DBG_BATMAN, "Drop packet: originator packet with tq equal 0 \n");
+		bat_dbg(DBG_BATMAN, "Drop packet: "
+				"originator packet with tq equal 0\n");
 		return;
 	}
 
 	if (is_my_oldorig) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast echos (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: "
+			"ignoring all rebroadcast echos (sender: %pM)\n",
+				ethhdr->h_source);
 		return;
 	}
 
@@ -484,7 +499,9 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 	    !(compare_orig(batman_packet->orig, batman_packet->prev_sender)) &&
 	    (compare_orig(orig_node->router->addr,
 			  orig_node->router->orig_node->router->addr))) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast packets that may make me loop (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: "
+			"ignoring all rebroadcast packets that may make me loop"
+				" (sender: %pM)\n", ethhdr->h_source);
 		return;
 	}
 
@@ -522,7 +539,8 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 		schedule_forward_packet(orig_node, ethhdr, batman_packet,
 					1, hna_buff_len, if_incoming);
 
-		bat_dbg(DBG_BATMAN, "Forwarding packet: rebroadcast neighbor packet with direct link flag\n");
+		bat_dbg(DBG_BATMAN, "Forwarding packet: "
+			"rebroadcast neighbor packet with direct link flag\n");
 		return;
 	}
 
diff --git a/drivers/staging/batman-adv/send.c b/drivers/staging/batman-adv/send.c
index 2a9fac8..acfb3ab 100644
--- a/drivers/staging/batman-adv/send.c
+++ b/drivers/staging/batman-adv/send.c
@@ -73,8 +73,9 @@ int send_skb_packet(struct sk_buff *skb,
 
 	if (!(batman_if->net_dev->flags & IFF_UP)) {
 		printk(KERN_WARNING
-		       "batman-adv:Interface %s is not up - can't send packet via that interface!\n",
-		       batman_if->dev);
+			"batman-adv:Interface %s is not up - "
+				"can't send packet via that interface!\n",
+					batman_if->dev);
 		goto send_skb_err;
 	}
 
@@ -155,7 +156,8 @@ static void send_packet_to_if(struct forw_packet *forw_packet,
 							    "Sending own" :
 							    "Forwarding"));
 		bat_dbg(DBG_BATMAN,
-			"%s %spacket (originator %pM, seqno %d, TQ %d, TTL %d, IDF %s) on interface %s [%s]\n",
+			"%s %spacket (originator %pM, seqno %d, TQ %d, "
+				"TTL %d, IDF %s) on interface %s [%s]\n",
 			fwd_str,
 			(packet_num > 0 ? "aggregated " : ""),
 			batman_packet->orig, ntohs(batman_packet->seqno),
@@ -185,7 +187,8 @@ static void send_packet(struct forw_packet *forw_packet)
 	unsigned char directlink = (batman_packet->flags & DIRECTLINK ? 1 : 0);
 
 	if (!forw_packet->if_incoming) {
-		printk(KERN_ERR "batman-adv: Error - can't forward packet: incoming iface not specified\n");
+		printk(KERN_ERR "batman-adv: Error - can't forward packet: "
+					"incoming iface not specified\n");
 		return;
 	}
 
@@ -199,7 +202,8 @@ static void send_packet(struct forw_packet *forw_packet)
 
 		/* FIXME: what about aggregated packets ? */
 		bat_dbg(DBG_BATMAN,
-			"%s packet (originator %pM, seqno %d, TTL %d) on interface %s [%s]\n",
+			"%s packet (originator %pM, seqno %d, TTL %d) "
+			"on interface %s [%s]\n",
 			(forw_packet->own ? "Sending own" : "Forwarding"),
 			batman_packet->orig, ntohs(batman_packet->seqno),
 			batman_packet->ttl, forw_packet->if_incoming->dev,
@@ -297,7 +301,7 @@ void schedule_forward_packet(struct orig_node *orig_node,
 	unsigned long send_time;
 
 	if (batman_packet->ttl <= 1) {
-		bat_dbg(DBG_BATMAN, "ttl exceeded \n");
+		bat_dbg(DBG_BATMAN, "ttl exceeded\n");
 		return;
 	}
 
@@ -316,7 +320,8 @@ void schedule_forward_packet(struct orig_node *orig_node,
 			batman_packet->tq = orig_node->router->tq_avg;
 
 			if (orig_node->router->last_ttl)
-				batman_packet->ttl = orig_node->router->last_ttl - 1;
+				batman_packet->ttl = orig_node->router->
+							last_ttl - 1;
 		}
 
 		tq_avg = orig_node->router->tq_avg;
@@ -325,9 +330,10 @@ void schedule_forward_packet(struct orig_node *orig_node,
 	/* apply hop penalty */
 	batman_packet->tq = hop_penalty(batman_packet->tq);
 
-	bat_dbg(DBG_BATMAN, "Forwarding packet: tq_orig: %i, tq_avg: %i, tq_forw: %i, ttl_orig: %i, ttl_forw: %i \n",
-		in_tq, tq_avg, batman_packet->tq, in_ttl - 1,
-		batman_packet->ttl);
+	bat_dbg(DBG_BATMAN, "Forwarding packet: tq_orig: %i, tq_avg: %i, "
+			"tq_forw: %i, ttl_orig: %i, ttl_forw: %i\n",
+				in_tq, tq_avg, batman_packet->tq, in_ttl - 1,
+					batman_packet->ttl);
 
 	batman_packet->seqno = htons(batman_packet->seqno);
 
diff --git a/drivers/staging/batman-adv/translation-table.c b/drivers/staging/batman-adv/translation-table.c
index d56f665..8de6939 100644
--- a/drivers/staging/batman-adv/translation-table.c
+++ b/drivers/staging/batman-adv/translation-table.c
@@ -77,11 +77,13 @@ void hna_local_add(uint8_t *addr)
 	   MAC-flooding. */
 	if ((num_hna + 1 > (ETH_DATA_LEN - BAT_PACKET_LEN) / ETH_ALEN) ||
 	    (num_hna + 1 > 255)) {
-		bat_dbg(DBG_ROUTES, "Can't add new local hna entry (%pM): number of local hna entries exceeds packet size \n", addr);
+		bat_dbg(DBG_ROUTES, "Can't add new local hna entry (%pM): "
+			"number of local hna entries exceeds packet size\n",
+				addr);
 		return;
 	}
 
-	bat_dbg(DBG_ROUTES, "Creating new local hna entry: %pM \n",
+	bat_dbg(DBG_ROUTES, "Creating new local hna entry: %pM\n",
 		addr);
 
 	hna_local_entry = kmalloc(sizeof(struct hna_local_entry), GFP_ATOMIC);
@@ -108,7 +110,7 @@ void hna_local_add(uint8_t *addr)
 				       hna_local_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:Couldn't resize local hna hash table \n");
+			printk(KERN_ERR "batman-adv:Couldn't resize local hna hash table\n");
 		else
 			hna_local_hash = swaphash;
 	}
@@ -197,7 +199,7 @@ static void _hna_local_del(void *data)
 static void hna_local_del(struct hna_local_entry *hna_local_entry,
 			  char *message)
 {
-	bat_dbg(DBG_ROUTES, "Deleting local hna entry (%pM): %s \n",
+	bat_dbg(DBG_ROUTES, "Deleting local hna entry (%pM): %s\n",
 		hna_local_entry->addr, message);
 
 	hash_remove(hna_local_hash, hna_local_entry->addr);
@@ -295,7 +297,8 @@ void hna_global_add_orig(struct orig_node *orig_node,
 			memcpy(hna_global_entry->addr, hna_ptr, ETH_ALEN);
 
 			bat_dbg(DBG_ROUTES,
-				"Creating new global hna entry: %pM (via %pM)\n",
+				"Creating new global hna entry: "
+					"%pM (via %pM)\n",
 				hna_global_entry->addr, orig_node->orig);
 
 			spin_lock_irqsave(&hna_global_hash_lock, flags);
@@ -340,7 +343,8 @@ void hna_global_add_orig(struct orig_node *orig_node,
 				       hna_global_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:Couldn't resize global hna hash table \n");
+			printk(KERN_ERR "batman-adv:"
+				"Couldn't resize global hna hash table\n");
 		else
 			hna_global_hash = swaphash;
 	}
@@ -365,7 +369,8 @@ int hna_global_fill_buffer_text(unsigned char *buff, int buff_len)
 
 		bytes_written += snprintf(buff + bytes_written,
 					  (2 * ETH_STR_LEN) + 10,
-					  " * %02x:%02x:%02x:%02x:%02x:%02x via %02x:%02x:%02x:%02x:%02x:%02x \n",
+					  " * %02x:%02x:%02x:%02x:%02x:%02x "
+					  "via %02x:%02x:%02x:%02x:%02x:%02x\n",
 					  hna_global_entry->addr[0],
 					  hna_global_entry->addr[1],
 					  hna_global_entry->addr[2],
@@ -388,7 +393,7 @@ int hna_global_fill_buffer_text(unsigned char *buff, int buff_len)
 void _hna_global_del_orig(struct hna_global_entry *hna_global_entry,
 			  char *message)
 {
-	bat_dbg(DBG_ROUTES, "Deleting global hna entry %pM (via %pM): %s \n",
+	bat_dbg(DBG_ROUTES, "Deleting global hna entry %pM (via %pM): %s\n",
 		hna_global_entry->addr, hna_global_entry->orig_node->orig,
 		message);
 
diff --git a/drivers/staging/batman-adv/vis.c b/drivers/staging/batman-adv/vis.c
index fedec1b..c75de68 100644
--- a/drivers/staging/batman-adv/vis.c
+++ b/drivers/staging/batman-adv/vis.c
@@ -216,7 +216,8 @@ static struct vis_info *add_packet(struct vis_packet *vis_packet,
 
 	/* repair if entries is longer than packet. */
 	if (info->packet.entries * sizeof(struct vis_info_entry) > vis_info_len)
-		info->packet.entries = vis_info_len / sizeof(struct vis_info_entry);
+		info->packet.entries =
+			vis_info_len / sizeof(struct vis_info_entry);
 
 	recv_list_add(&info->recv_list, info->packet.sender_orig);
 
@@ -361,14 +362,17 @@ static int generate_vis_packet(void)
 	while (hash_iterate(orig_hash, &hashit_global)) {
 		orig_node = hashit_global.bucket->data;
 		if (orig_node->router != NULL
-			&& compare_orig(orig_node->router->addr, orig_node->orig)
+			&& compare_orig(orig_node->router->addr,
+				orig_node->orig)
 			&& orig_node->batman_if
 			&& (orig_node->batman_if->if_active == IF_ACTIVE)
 		    && orig_node->router->tq_avg > 0) {
 
 			/* fill one entry into buffer. */
 			entry = &entry_array[info->packet.entries];
-			memcpy(entry->src, orig_node->batman_if->net_dev->dev_addr, ETH_ALEN);
+			memcpy(entry->src,
+				orig_node->batman_if->net_dev->dev_addr,
+					ETH_ALEN);
 			memcpy(entry->dest, orig_node->orig, ETH_ALEN);
 			entry->quality = orig_node->router->tq_avg;
 			info->packet.entries++;
-- 
1.6.4.4



